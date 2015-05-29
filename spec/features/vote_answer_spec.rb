require_relative 'features_helper'

RSpec.feature 'Vote an answer', %q{
  To promote an answer
  As an authenticated user
  I want to vote for it
}, type: :feature, js: true do

  given (:question_author) { create(:user) }
  given (:answer_author) { create(:user) }
  given (:question) { create(:question, user: question_author) }
  given! (:answer) { create(:answer, question: question, user: answer_author) }
  given! (:second_answer) { create(:answer, question: question, user: question_author) }

  background do
    sign_in(question_author)
    visit question_path(question)
  end

  scenario 'User can vote for answer' do
    within "#vote_for_Answer_#{ answer.id }" do
      expect(page).to have_link 'vote up'
      expect(page).to have_link 'vote down'
      expect(page).to have_text 'Score: 0'
    end
  end

  scenario 'User can vote for answer only once' do
    within "#vote_for_Answer_#{ answer.id }" do
      click_link 'vote up'
      expect(page).to have_text 'Score: 1'
      expect(page).to_not have_link 'vote up'
      expect(page).to have_text 'Cancel my vote'
    end
  end

  scenario 'User can cancel his vote and re-vote' do
    within "#vote_for_Answer_#{ answer.id }" do
      click_link 'vote up'
      expect(page).to have_text 'Score: 1'
      click_link 'Cancel my vote'
      expect(page).to have_text 'Score: 0'
      click_link 'vote down'
      expect(page).to have_text 'Score: -1'
    end
  end

  scenario 'User can not vote for his answer' do
    within "#vote_for_Answer_#{ second_answer.id }" do
      expect(page).to_not have_link 'vote up'
      expect(page).to_not have_link 'vote down'
    end
  end
end
