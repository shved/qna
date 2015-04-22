require_relative 'features_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answers author
  I want to be able to attach files
}, type: :feature do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when gives answer', js: true do
    fill_in 'Answer', with: 'Test answer text body answer text body'
    click_on 'Add one more file'
    attach_file 'File', "#{ Rails.root }/spec/spec_helper.rb"
    click_on 'Submit'

    save_and_open_page

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
