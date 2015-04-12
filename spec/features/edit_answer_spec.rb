require_relative 'features_helper'

RSpec.feature 'Edit an answer', %q{
  In order to fix a mistake
  As an author of answer
  I want to be able to edit my answer
}, type: :feature do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:other_question) { create(:question) }
  given!(:others_answer) { create(:answer, question: other_question) }

  scenario 'A user edit his answer', js: true do
    sign_in answer.user
    visit question_path question

    within '.answers' do
      click_on 'Edit answer'
      fill_in 'Answer', with: 'edited answer long enough to be valid'
      click_on 'Save'
    end

    expect(page).to_not have_content answer.body
    expect(page).to have_content 'edited answer long enough to be valid'
  end

  scenario 'A user can not edit an another users answer', js: true do
    sign_in answer.user
    visit question_path other_question

    expect(page).to_not have_selector(:link_or_button, 'Edit answer')
  end

  scenario 'An unauthenticated user can not edit answer', js: true do
    visit question_path question

    expect(page).to_not have_selector(:link_or_button, 'Edit answer')
  end
end
