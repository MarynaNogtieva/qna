require_relative '../acceptance_helper'

feature 'Author can mark answer to be the best one', '
In order to let people know which of the answers solved my problem
As an author of the question
I want to be able to mark the answer as the best one' do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'An authenticated user as an author of the question ' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'Can mark best answer', js: true do
      within ".answers" do
        click_on 'Best Answer'
        expect(page).to have_css 'div.best-answer'
      
        within '.best-answer' do
          expect(page).to_not have_button 'Best answer'
        end
      end 
    end
  end

  scenario 'Not an author cannot mark answer to be the best' do
    sign_in(not_author)

    visit question_path(question)
    expect(page).to_not have_content 'Best Answer'
  end

  scenario 'Non-authenticated user cannot see best answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Best Answer'
  end
end