require_relative 'features_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author
  I want to be able to attach files
}, type: :feature do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'this is just question body long enough to be valid'
    click_on 'Add one more file'
    click_on 'Add one more file'
    inputs = all("input[type='file']")
    inputs[0].set("#{ Rails.root }/spec/spec_helper.rb")
    inputs[1].set("#{ Rails.root }/config.ru")
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'config.ru', href: '/uploads/attachment/file/2/config.ru'
  end
end
