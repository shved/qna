require_relative 'features_helper'

RSpec.feature 'User can vote', %q{
  To like a question
  As a registered user
  I'd like to vote for it
}, type: :feature, js: true do

  given! (:user1) { create(:user) }
  given! (:user2) { create(:user) }
  given! (:question) { create(:question, user: user1) }
  given! (:second_question) { create(:question, user: user2) }

  background do
    sign_in(user2)
    visit question_path(question)
  end

  scenario 'User can vote for question' do
    within "#question_#{ question.id }" do
      expect(page).to have_text 'Like'
      expect(page).to have_text 'Dislike'
      expect(page).to have_text 'Rating is: 0'
    end
  end

  scenario 'User can vote for question only once' do
    within "#question_#{ question.id }" do
      click_link 'Like'
      expect(page).to have_text 'Rating is: 1'
      expect(page).to_not have_text 'Like'
      expect(page).to have_text 'Withdraw'
    end
  end

  scenario 'User can cancel his vote and re-vote' do
    within "#question_#{ question.id }" do
      click_link 'Like'
      expect(page).to have_text 'Rating is: 1'
      click_link 'Withdraw'
      expect(page).to have_text 'Rating is: 0'
      click_link 'Dislike'
      expect(page).to have_text 'Rating is: -1'
    end
  end

  scenario 'User can not vote for his question' do
    visit question_path(second_question)
    within "#question_#{ second_question.id }" do

      expect(page).to_not have_text 'Like'
      expect(page).to_not have_text 'Dislike'
    end
  end
end
