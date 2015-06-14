require_relative 'features_helper'

RSpec.feature 'Comment an answer', %q{
  In order to extend an answer
  as an authenticated user
  I want to be able to comment an answer
}, type: :feature do
  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:answer) { create :answer, user: user, question: question }
  given(:comment) { create :comment }

  context 'Authenticated user' do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'creates a comment', js: true do
      within '.answer .comments' do
        click_on 'Leave a comment'
        fill_in 'Your comment', with: comment.body
        click_on 'Submit'
        expect(page).to have_content comment.body
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path question }

    scenario 'can not comment an answer' do
      within '.answer .comments' do
        expect(page).not_to have_link 'Leave a comment'
      end
    end
  end
end
