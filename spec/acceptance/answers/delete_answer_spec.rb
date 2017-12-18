require 'rails_helper'

feature 'Dele answer', '
In order to delete outdated or incorrect answer
As an authenticated user and an author of the answer
I want to be able to delete answer to a question' do

  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'The author of the question tries to remove it' do
    sign_in(author)

    visit question_path(question)
    click_on 'Delete Answer'
    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Your answer was successfully deleted.'
  end

  scenario 'Not an author cannot delete a question' do
    sign_in(not_author)

    visit question_path(question)
    expect(page).to_not have_content 'Delete Answer'
  end

  scenario 'Non-authenticated user cannot delete a question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete Answer'
  end
end