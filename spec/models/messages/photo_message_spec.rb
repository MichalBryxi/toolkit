# == Schema Information
#
# Table name: photo_messages
#
#  id            :integer          not null, primary key
#  thread_id     :integer          not null
#  message_id    :integer          not null
#  created_by_id :integer          not null
#  photo_uid     :string(255)      not null
#  caption       :string(255)
#  description   :text
#  created_at    :datetime         not null
#

require 'spec_helper'

describe PhotoMessage do
  describe 'associations' do
    it { should belong_to(:message) }
    it { should belong_to(:thread) }
    it { should belong_to(:created_by) }
  end

  describe 'validations' do
    it { should validate_presence_of(:photo) }
  end

  context 'factory' do
    subject { FactoryGirl.create(:photo_message) }

    it { should be_valid }

    it 'should have a thread' do
      subject.thread.should be_a(MessageThread)
    end

    it 'should have a message' do
      subject.message.should be_a(Message)
    end
  end

  context 'photo thumbnail' do
    subject { FactoryGirl.create(:photo_message) }

    it 'should provide a thumbnail of the photo' do
      subject.photo_thumbnail.should be_true
      subject.photo_thumbnail.width.should == 46
      subject.photo_thumbnail.height.should == 50
    end
  end

  context 'photo preview' do
    subject { FactoryGirl.create(:photo_message) }

    it 'should provide a preview size of the photo' do
      subject.photo_preview.should be_true
      subject.photo_preview.width.should == 182
      subject.photo_preview.height.should == 200
    end
  end

  context 'searchable text' do
    subject { FactoryGirl.create(:photo_message_with_description) }

    it 'should contain the caption' do
      subject.searchable_text.should include(subject.caption)
    end

    it 'should contain the description' do
      subject.searchable_text.should include(subject.description)
    end
  end
end
