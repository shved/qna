require_relative 'features_helper'

RSpec.feature 'User registration', %q{
  In order to create questions and answers
  As a non-registered user
  I want to create new account
}, type: :feature do

  given(:user) { build(:user) }

  scenario 'Non-registered user creates new account' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content 'You have signed up successfully.'
  end
end
