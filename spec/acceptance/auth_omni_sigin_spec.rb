require_relative 'acceptance_helper'

feature 'Sign in with social networks accounts', '
In order to ask and answer questions
As a user
I want to be able to sign in via social networks accounts' do
  given(:user) { create(:user) }
  given(:email) { 'test@example.com' }

  describe 'Sign in via Facebook' do
    scenario 'User is not registered yet', js: true do
      # mock_auth_hash(:facebook, nil)
      # user.update!(email: email)
      # visit new_user_session_path
      # click_on 'Sign in with Facebook'

      # click_on 

      # expect(page).to have_content('Successfully authenticated from Facebook account.')
    end

    scenario 'User is registered already', js: true do
      # auth = mock_auth_hash(:facebook, user.email)
      # create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      # visit new_user_session_path
      # click_on 'Sign in with Facebook'

      # expect(page).to have_content('Successfully authenticated from Facebook account.')
    end
  end


  describe 'Sign in via Twitter' do
    scenario 'User is not registered yet', js: true do
      mock_auth_hash(:twitter, nil)

      visit new_user_session_path

      click_on 'Sign in with Twitter'
      save_and_open_screenshot
     sleep(7)
     within '.form-group' do
      fill_in 'Email', with: "test@example.com"
     end
      expect(page).to have_content 'Email is required to finish registration'

      # fill_in 'Email', with: "test@example.com"
      # click_on 'Confim email'

      # message = ActionMailer::Base.deliveries.last.body.raw_source
      # doc = Nokogiri::HTML.parse(message)
      # url = doc.css("a").map { |link| link[:href] }.first
      # visit url

      # click_on 'Sign in with Twitter'

      # expect(page).to have_content('Succes login!')
    end

    # scenario 'User is registered already', js: true do
    #   auth = mock_auth_hash(:facebook, user.email)
    #   create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

    #   visit new_user_session_path
    #   click_on 'Sign in with Facebook'

    #   expect(page).to have_content('Successfully authenticated from Facebook account.')
    # end
  end
end