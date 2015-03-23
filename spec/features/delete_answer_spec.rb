require 'rails_helper'

RSpec.feature 'Delete an answer', %q{
  As an author of answer
  I want to be able to delete my answer
}, type: :feature do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:other_question) { create(:question) }
  given!(:others_answer) { create(:answer, question: other_question) }

  scenario 'A user deletes his question' do
    sign_in(answer.user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_content answer.body
  end

  scenario 'A user can not delete an another users answer' do
    sign_in(answer.user)
    visit question_path(other_question)

    expect(page).to_not have_selector(:link_or_button, 'Delete question')
  end

  scenario "An unauthenticated user can not delete question" do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete question')
  end
end
