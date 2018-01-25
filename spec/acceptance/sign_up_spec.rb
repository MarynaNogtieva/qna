require_relative 'acceptance_helper'

feature 'User sign up', '
    In order to be able to ask questions and post answers
    As an user
    I want to be able to sign up' do

  scenario 'User sign up with valid attributes' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '0987654321'
    fill_in 'Password confirmation', with: '0987654321'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_link 'Logout'
  end

  scenario 'User sign up with invalid attributes' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newuser'
    fill_in 'Password', with: '0987654321'
    fill_in 'Password confirmation', with: '0987655321'
    click_on 'Sign up'

    expect(page).to have_content '2 errors prohibited this user from being saved:'
    expect(page).to_not have_link 'Logout'
  end
end