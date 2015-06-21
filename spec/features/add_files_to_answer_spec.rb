require_relative 'features_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answers author
  I want to be able to attach files
}, type: :feature do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds few files when gives answer', js: true do
    fill_in 'Answer', with: 'Test answer text body answer text body answer text'
    click_on 'Add one more file'
    click_on 'Add one more file'
    inputs = all("input[type='file']")
    inputs[0].set("#{ Rails.root }/spec/spec_helper.rb")
    inputs[1].set("#{ Rails.root }/config.ru")
    click_on 'Submit'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'config.ru', href: '/uploads/attachment/file/2/config.ru'
    end
  end
end
