require_relative '../acceptance_helper'

feature 'Dele question', '
In order to delete outdated or incorrect question
As an authenticated user and an author of the question
I want to be able to delete question' do

  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) {create(:question, user: author)}

  scenario 'The author of the question tries to remove it' do
    sign_in(author)

    visit question_path(question)
    click_on 'Delete Question'
    expect(page).to have_content 'Your question was successfully deleted.'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Not an author cannot delete a question' do
    sign_in(not_author)

    visit question_path(question)
  
    expect(page).to_not have_content 'Delete Question'
  end

  scenario 'Non-authenticated user cannot delete a question' do
    visit question_path(question)
  
    expect(page).to_not have_content 'Delete Question'
  end
end