require 'rails_helper'

RSpec.feature 'View questions', %q{
  In order to find common questions
  As a user
  I want to be able to view questions list and separate questions
}, type: :feature do

  given(:questions) { create_list(:question, 2) }
  given(:answer) { questions.each { |q| create(:answer, question: q) } }

  scenario 'User views questions index' do
    visit questions_path

    questions.each { expect(page).to have_content q.title }
  end

  scenario 'User views question with answers' do
    visit questions_path
    click_on questions[0].title

    expect(page).to have_content question[0].answers[0].body
  end
end
