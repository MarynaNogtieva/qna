require 'rails_helper'

feature 'Create answer', '
In order to help someone to solve his/her problem
As a user
I want to be able to answer their question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  
  scenario 'A user tries to create an answer with valid attributes' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your Answer', with: 'Answer test for the test question'
    click_on 'Answer a question'

    expect(page).to have_content 'Answer test for the test question'
    expect(page).to have_content 'Your was created successfully'
  end

  scenario 'A user tries to create an answer with invalid attributes' do
    sign_in(user)
    visit question_path(question)
    
    fill_in 'Your Answer', with: ' '
    click_on 'Answer a question'

    expect(page).to have_content 'Something is wrong'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Your Answer'
    expect(page).to_not have_content 'Post Your Answer'
  end
end