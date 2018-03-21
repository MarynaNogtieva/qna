require_relative 'acceptance_helper'

feature 'Sign in with social networks accounts', '
In order to ask and answer questions
As a user
I want to be able to sign in via social networks accounts' do
  given(:user) { create(:user) }

  describe 'Sign in via Facebook' do
    scenario 'User is not registered yet', js: true do
      mock_auth_hash(:facebook)
      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end

    scenario 'User is registered already', js: true do
      auth = mock_auth_hash(:facebook, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end
  end
end