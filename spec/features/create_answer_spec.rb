require_relative 'features_helper'

RSpec.feature 'Create answer', %q{
  In order to answer the question
  As an authenticated user
  I want to be able to create an answer
}, type: :feature do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user answers the question', js: true do
    sign_in user
    visit question_path(question)
    fill_in 'Answer', with: answer.body
    click_on 'Submit'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'User tries to create invalid answer', js: true do
    sign_in user
    visit question_path(question)
    fill_in 'Answer', with: 'asdf'
    click_on 'Submit'

    within('.answers') { expect(page).to_not have_content 'asdf' }
  end

  scenario 'Non-authenticated user tries to answer the question', js: true do
    visit question_path(question)
    expect(page).to_not have_field 'Your answer'
    expect(page).to_not have_selector(:link_or_button, 'Submit')
  end
end
