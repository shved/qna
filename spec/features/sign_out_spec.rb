require_relative 'features_helper'

RSpec.feature '', %q{
  As an authenticated user
  I want to to sign out
}, type: :feature do
  given(:user) { create(:user) }

  scenario 'An authenticated user signs out' do
    sign_in user
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to_not have_selector(:link_or_button, 'Sign out')
    expect(current_path).to eq root_path
  end
end
