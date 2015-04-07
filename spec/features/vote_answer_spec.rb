require_relative 'features_helper'

RSpec.feature 'Rate an answer', %q{
  In order to promote the answer
  As a guest
  I want to be able to vote for my favorite answer
}, type: :feature do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'A user votes an answer', js: true do
    visit question_path question

    within '.answers' do
      click_on '+'
    end

    expect(page).to have_content '1'
  end
end
