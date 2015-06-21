require_relative 'features_helper'

RSpec.feature 'User can login with OAuth', %q{
  In order to sign up
  As a user
  I can login with OAuth
}, type: :feature do
  before do
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '123456'
    )

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '123456',
      info: { email: 'test@facebook.com' }
    )
  end

  describe 'login with facebook' do
    before do
      visit new_user_session_path
    end

    scenario 'sign in user' do
      click_on 'Sign in with Facebook'

      expect(page).to have_content('You have to confirm your email address before continuing.')
    end

    scenario 'handle authentication error' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_on 'Sign in with Facebook'

      expect(page).to have_content('Sign in with Facebook')
      expect(page).to have_content('Could not authenticate you from Facebook')
    end
  end

  describe 'login with twitter' do
    let(:user) { build :user }
    let!(:existing_user) { create :user }

    before do
      visit new_user_session_path
      click_on 'Sign in with Twitter'
    end

    scenario 'with valid email' do
      fill_in 'auth[info][email]', with: user.email
      click_on 'Submit'
      expect(page).to have_content('You have to confirm your email address before continuing.')
    end

    scenario 'with invalid email' do
      click_on 'Submit'
      expect(page).to have_content 'Please enter valid email'
    end

    scenario 'handle authentication error' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      click_on 'Sign in with Twitter'
      expect(page).to have_content('Sign in with Twitter')
      expect(page).to have_content('Could not authenticate you from Twitter')
    end
  end
end
