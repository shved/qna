require_relative 'features_helper'

RSpec.feature 'User can login with OAuth', %q{
  In order to sign up
  As a user
  I can login with OAuth
}, type: :feature do
  before do
    mock_auth_hash
  end
  describe 'login with facebook' do
    before { visit new_user_session_path }
    scenario 'sign in user' do
      click_on 'Sign in with Facebook'
      expect(page).to have_content('test@facebook.com')
      expect(page).to have_content('Successfully authenticated from Facebook account.')
      expect(page).to have_content('Sign out')
    end

    scenario 'handle authentication error' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Sign in with Facebook')
      expect(page).to have_content('Could not authenticate you from Facebook')
    end
  end

  describe 'Login with twitter' do
    let(:user) { build :user }
    let!(:existing_user) { create :user }
    before do
      visit new_user_session_path
      click_on 'Sign in with Twitter'
    end

    scenario 'with valid email' do
      fill_in 'Email', with: user.email
      click_on 'Submit'
      expect(page).to have_content('Successfully authenticated from Twitter account.')
      expect(page).to have_content('Sign out')
    end

    scenario 'with invalid email' do
      click_on 'Submit'
      expect(page).to have_content 'Please enter valid email'
    end

    scenario 'can handle authentication error' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      click_on 'Sign in with Twitter'
      expect(page).to have_content('Sign in with Twitter')
      expect(page).to have_content('Could not authenticate you from Twitter')
    end
  end
end
