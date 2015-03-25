require 'rails_helper'

RSpec.feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
}, type: :feature do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'ask it here'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'this is just question body long enough to be valid'
    click_on 'Create'

    expect(current_path).to eq question_path(Question.last)
    expect(page).to have_content 'Test question title'
    expect(page).to have_content 'this is just question body long enough to be valid'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'ask it here'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
