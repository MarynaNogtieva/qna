require_relative '../acceptance_helper'

feature 'Create answer', '
In order to help someone to solve his/her problem
As a user
I want to be able to answer their question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'An authenticated user tries to create an answer with valid attributes', js: true do
    sign_in(user)
    confirm_email(user.email)
    sign_in(user)
    visit question_path(question)

    fill_in 'Your Answer', with: 'Answer test for the test question'
    click_on 'Answer a question'
    
    within '.answers' do
      expect(page).to have_content 'Answer test for the test question'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'An authenticated user tries to create an answer with invalid attributes',js: true do
    sign_in(user)
    confirm_email(user.email)
    sign_in(user)
    visit question_path(question)
    
    fill_in 'Your Answer', with: ' '
    click_on 'Answer a question'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create an answer', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Your Answer'
    expect(page).to_not have_content 'Post Your Answer'
  end


  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        confirm_email(user.email)
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your Answer', with: 'Answer test for the test question'
        click_on 'Answer a question'
        
        within '.answers' do
          expect(page).to have_content 'Answer test for the test question'
        end
        sleep(5)
      end

      # Capybara.using_session('guest') do
      #   within '.answers' do
      #     expect(page).to have_content 'Answer test for the test question'
      #   end
      # end
    end
  end


end