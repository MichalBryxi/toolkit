require 'spec_helper'

describe 'Group memberships admin' do
  let(:group) { FactoryGirl.create(:group) }

  context 'as an admin' do
    include_context 'signed in as admin'

    context 'new' do
      before do
        visit new_group_membership_path(group)
      end

      it 'should show the new member form' do
        page.should have_field('Full name')
        page.should have_field('Email')
      end
    end

    context 'create' do
      before do
        visit new_group_membership_path(group)
      end

      it 'should create a new group member and send an invitation email' do
        choose 'Member'
        fill_in 'Full name', with: 'Brian Griffin'
        fill_in 'Email', with: 'briang@example.com'
        click_button 'Add member'
        User.find_by_email('briang@example.com').should be_true
        email = open_email 'briang@example.com'
        email.subject.should =~ /Invitation/
      end

      it 'should display an error if a name is not given' do
        choose 'Member'
        click_button 'Add member'
        page.should have_content('Please enter a name')
      end

      context 'with existing user' do
        let(:new_member) { FactoryGirl.create(:user) }

        it 'should use an existing user if present' do
          choose 'Member'
          fill_in 'Email', with: new_member.email
          click_button 'Add member'
          User.find_by_email(new_member.email).groups.should include(group)
        end
      end
    end
  end

  context 'as a group committee member' do
    include_context 'signed in as a committee member'

    before do
      visit new_group_membership_path(current_group)
    end

    context 'new' do
      it 'should show the page' do
        page.status_code.should == 200
      end
    end

    context 'create' do
      context 'for unregistered users'
        it 'should create a new group member and send an invitation email' do
          choose 'Member'
          fill_in 'Full name', with: 'Meg Griffin'
          fill_in 'Email', with: 'meg@example.com'
          click_button 'Add member'
          User.find_by_email('meg@example.com').should be_true
          email = open_email 'meg@example.com'
          email.subject.should =~ /Invitation/

          # Ensure they only get one invitation email and not e.g. added to group email
          all_emails.count.should eql(1)
        end

      context 'for existing users' do
        let(:new_member) { FactoryGirl.create(:user) }

        it 'should send a confirmation email' do
          choose 'Member'
          fill_in 'Email', with: new_member.email
          click_button 'Add member'
          email = open_email new_member.email
          email.subject.should =~ /You are now a member/

          all_emails.count.should eql(1)
        end
      end
    end

    context 'edit' do
      let(:meg) { FactoryGirl.create(:meg) }

      it 'should let you promote a member into the committee' do
        FactoryGirl.create(:group_membership, group: current_group, user: meg)
        current_group.committee_members.should_not include(meg)

        visit group_members_path(current_group)
        within('.members') do
          click_on 'Edit membership'
        end
        choose 'Committee'
        click_on 'Save'

        within('.committee') do
          page.should have_content(meg.name)
        end
        current_group.committee_members.should include(meg)
      end
    end
  end
end
