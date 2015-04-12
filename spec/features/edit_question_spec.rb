require_relative 'features_helper'

RSpec.feature 'Edit a question', %q{
  In order to fix a mistake
  As an author of question
  I want to be able to edit my question
}, type: :feature do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question) }

  scenario 'A user edit his question', js: true do
    sign_in question.user
    visit question_path question
    click_on 'Edit question'
    fill_in 'Title', with: 'edited question title long enough to be valid'
    fill_in 'Body', with: 'edited question body long enough to be valid'
    click_on 'Save'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(page).to have_content 'edited question title long enough to be valid'
    expect(page).to have_content 'edited question body long enough to be valid'
  end

  scenario 'A user can not edit an another users question', js: true do
    sign_in question.user
    visit question_path other_question

    expect(page).to_not have_selector(:link_or_button, 'Edit question')
  end

  scenario 'An unauthenticated user can not edit question', js: true do
    visit question_path question

    expect(page).to_not have_selector(:link_or_button, 'Edit question')
  end
end
