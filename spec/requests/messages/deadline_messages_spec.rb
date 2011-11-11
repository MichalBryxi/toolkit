require "spec_helper"

describe "Deadline messages" do
  let(:thread) { FactoryGirl.create(:message_thread) }

  def deadline_form
    within("#new-deadline-message") { yield }
  end

  context "new", as: :site_user do
    before do
      visit thread_path(thread)
    end

    it "should post a new deadline message" do
      future_date = Date.current + 5.days
      deadline_form do
        fill_in "Deadline", with: future_date.to_s
        fill_in "Title", with: "Submission deadline"
        fill_in "Message", with: "Do this by then!"
        click_on "Create Deadline message"
      end
      page.should have_content(future_date.strftime("%d %B %Y"))
      page.should have_content("Submission deadline")
      page.should have_content("Do this by then!")
    end
  end
end
