require_relative 'features_helper'

RSpec.feature 'User sign in', %q{
  In order to create questions and answers
  As a non-authenticated user
  I want to sign in
}, type: :feature do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do

    visit new_user_session_path
    fill_in 'Email', with: 'wrong@mail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end
