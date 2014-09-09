require 'spec_helper'

describe 'Library notes' do
  let(:note) { FactoryGirl.create(:library_note) }

  context 'as a public user' do
    before do
      visit library_note_path(note)
    end

    it 'should show the note body' do
      page.should have_content(note.body)
    end

    it "should link to the creator's profile" do
      page.should have_link(note.created_by.name)
    end

    it 'should show the date when it was created' do
      page.should have_content(I18n.localize(note.created_at.to_date))
    end

    it 'should not show a link to edit tags' do
      page.should_not have_content(I18n.t('.shared.tags.panel.edit_tags'))
    end
  end

  context 'new', as: :site_user do
    it 'should create a new note' do
      visit new_library_note_path
      fill_in 'Note', with: 'Note text goes here'
      click_on 'Create Note'
      page.should have_content('Note text goes here')
    end

    it 'should auto link the text' do
      visit new_library_note_path
      fill_in 'Note', with: 'Text https://example.com more text'
      click_on 'Create Note'
      page.should have_link('https://example.com')
    end

    it 'should create tags for the note' do
      visit new_library_note_path
      fill_in 'Note', with: 'blah blah blah'
      fill_in 'Tags', with: 'one two three'
      click_on 'Create Note'
      page.should have_content('three')
    end

    it 'should have a cancel link back to the library page' do
      visit new_library_note_path
      click_on 'Cancel'
      page.current_path.should == library_path
    end
  end

  context 'with document' do
    let(:note) { FactoryGirl.create(:library_note_with_document) }

    before do
      visit library_note_path(note)
    end

    it 'should show the document title' do
      page.should have_content(note.document.title)
    end
  end

  context 'tags' do
    include_context 'signed in as a site user'

    before do
      visit library_note_path(note)
    end

    it 'should be taggable' do
      click_on 'Edit tags'
      fill_in 'Tags', with: 'cycle parking'
      click_on I18n.t('.formtastic.actions.library_item.update_tags')
      JSON.parse(page.source)['tagspanel'].should have_content('parking')
    end
  end

  context 'edit' do
    let(:edit_text) { I18n.t('.library.notes.show.edit') }
    context 'as an admin' do
      include_context 'signed in as admin'

      it 'should show you a link' do
        visit library_note_path(note)
        page.should have_link(edit_text)
      end

      it 'should let you edit the note' do
        visit library_note_path(note)
        click_on edit_text

        page.should have_content(I18n.t('.library.notes.edit.title'))
        fill_in 'Note', with: 'Something New and Very Useful'
        click_on 'Save'
        current_path.should == library_note_path(note)
        page.should have_content('Something New and Very Useful')
      end
    end

    context 'as the creator' do
      include_context 'signed in as a site user'

      context 'recent' do
        let(:note) { FactoryGirl.create(:library_note, created_by: current_user) }
        it 'should show you a link' do
          visit library_note_path(note)
          page.should have_link(edit_text)
        end
      end

      context 'long ago' do
        let(:note) { FactoryGirl.create(:library_note, created_by: current_user) }
        it 'should not show you a link' do
          note.item.update_attribute(:created_at, 2.days.ago)

          visit library_note_path(note)
          page.should_not have_link(edit_text)
        end
      end
    end

    context 'as another user' do
      include_context 'signed in as a site user'

      it 'should not show you a link' do
        visit library_note_path(note)
        page.should_not have_link(edit_text)
      end
    end
  end
end
