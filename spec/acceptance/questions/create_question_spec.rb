require_relative '../acceptance_helper'


feature 'Create question', '
In order to get answer from the community
As an authenticated user
I want to be able to ask question
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)
    confirm_email(user.email)
    sign_in(user)

    visit questions_path
    create_question
  end

  scenario 'Authenticated user tries to create a  question with invalid attributes' do
    sign_in(user)
    confirm_email(user.email)
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        confirm_email(user.email)
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        create_question
        sleep(5)
      end

      # Capybara.using_session('guest') do
      #   expect(page).to have_content 'Test question'
      # end
    end
  end

  def create_question
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created.'
    expect(page).to have_content 'Test question'
  end
end