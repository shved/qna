require 'rails_helper'

RSpec.feature 'Create answer', %q{
  In order to answer the question
  As an authenticated user
  I want to be able to create an answer
}, type: :feature do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user answers the question' do
    sign_in user
    visit question_path(question)
    click_on 'Submit new answer'
    fill_in 'Answer', with: answer.body
    click_on 'Submit'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content answer.body
  end

  scenario 'Non-authenticated user tries to answer the question' do
    visit question_path(question)
    expect(page).to_not have_field 'Your answer'
  end
end
