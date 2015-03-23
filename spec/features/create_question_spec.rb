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
    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@mail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit questions_path
    click_on 'ask it here'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
