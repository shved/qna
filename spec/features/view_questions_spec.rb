require_relative 'features_helper'

RSpec.feature 'View questions', %q{
  In order to find common questions
  As a user
  I want to be able to view questions list and separate questions
}, type: :feature do

  given!(:questions) { create_list(:question, 2) }
  given!(:answer) { questions.each { |q| create(:answer, question: q) } }

  scenario 'User views questions index' do
    visit questions_path

    questions.each { |q| expect(page).to have_content q.title }
  end

  scenario 'User views question with answers' do
    visit questions_path
    click_link(questions[0].title, match: :first)

    expect(page).to have_content questions[0].answers[0].body
  end
end
