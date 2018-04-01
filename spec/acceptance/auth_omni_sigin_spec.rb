require_relative 'acceptance_helper'

feature 'Sign in with social networks accounts', '
In order to ask and answer questions
As a user
I want to be able to sign in via social networks accounts' do
  given(:user) { create(:user) }
  given(:email) { 'test@example.com' }

  describe 'Sign in via Facebook' do
    scenario 'User is not registered yet', js: true do
      mock_auth_hash(:facebook)
      user.update!(email: email)
     
      visit new_user_session_path
      click_on 'Sign in with Facebook'
   
      expect(page).to have_content('You have to confirm your email address before continuing')

      # for some reason it does not open email automatically in the test case
      click_on "Didn't receive confirmation instructions?"
      fill_in 'Email', with: email
      click_on 'Resend confirmation instructions'
      open_email(email)
     
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed')
    end

    scenario 'User is registered already', js: true do
      auth = mock_auth_hash(:facebook, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content('You have to confirm your email address before continuing')

      open_email(user.email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed')
    end
  end


  describe 'Sign in via Twitter' do
    scenario 'User is not registered yet', js: true do
      mock_auth_hash(:twitter, nil)
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Email is required to finish registration'
     
      within '.form-group' do
        fill_in 'Email', with: 'test@example.com'
      end
      click_on 'Confirm email'
      sleep(2)
      open_email('test@example.com')

      expect(page).to have_content('You have to confirm your email address before continuing')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed')
    end

    scenario 'User is registered already', js: true do
      auth = mock_auth_hash(:twitter, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid )

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('You have to confirm your email address before continuing')

      open_email(user.email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed')
    end
  end
end