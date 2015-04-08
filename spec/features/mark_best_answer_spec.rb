require_relative 'features_helper'

RSpec.feature 'Mark the best answer', %q{
  In order to promote best answer
  As the question author
  I want to be able to mark an answer as the best one
}, type: :feature do

  given(:author) { create(:user) }
  given(:guest) { create(:user) }

  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question, user: guest) }

  scenario 'Author marks an answer as the best', js: true do
    sign_in author
    visit question_path question
    answer = answers.at(0)

    within "#answer-#{ answer.id }" do
      click_on "make-best-#{ answer.id }"

      expect(page).to have_content 'The best answer'
      expect(page).to_not have_content 'Make best'
    end
  end

  scenario 'Guest cant mark answer as best', js: true do
    sign_in guest
    visit question_path question

    expect(page.find('.answers')).to_not have_content 'Make best'
  end
end
