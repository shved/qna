require_relative 'features_helper'

RSpec.feature 'Delete a question', %q{
  As an author of question
  I want to be able to delete my question
}, type: :feature do
  given!(:user) { create(:user) }
  given(:my_question) { create(:question, user: user) }
  given(:others_question) { create(:question, title: 'asdfkjsdlkfjsldkfjsldkfjsdlkfjsdlkfj') }

  scenario 'A user deletes his question' do
    sign_in(my_question.user)
    visit question_path(my_question)
    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).to_not have_content(my_question.title)
  end

  scenario 'A user can not delete an another users question' do
    sign_in(my_question.user)
    visit question_path(others_question)

    expect(page).to_not have_selector(:link_or_button, 'Delete question')
  end

  scenario "An unauthenticated user can not delete question" do
    visit question_path(others_question)

    expect(page).to_not have_selector(:link_or_button, 'Delete question')
  end
end
