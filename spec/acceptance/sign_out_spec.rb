require_relative 'acceptance_helper'

feature 'User sign out', '
In order to finish my session on the website
I as a user
Want to be able to signout' do
  given(:user) { create(:user) }
  scenario 'Signed in user tries to logout' do
    sign_in(user)
    confirm_email(user.email)
    sign_in(user)
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq '/'
  end
end
