require_relative '../acceptance_helper'
require 'byebug'
feature 'Author can mark answer to be the best one', '
In order to let people know which of the answers solved my problem
As an author of the question
I want to be able to mark the answer as the best one' do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:another_answer) { create(:answer, question: question, user: not_author) }

  describe 'An authenticated user as an author of the question ' do
    before do
      sign_in(author)
      confirm_email(author.email)
      sign_in(author)
      visit question_path(question)
    end

    scenario 'Can mark best answer', js: true do
      within ".answers" do
        within "#answer-id-#{answer.id}" do
          click_on 'Best Answer'
        end
        expect(page).to have_css 'div.best-answer'
      
        within '.best-answer' do
          expect(page).to_not have_button 'Best answer'
        end
      end 
    end

    scenario 'Can see the best answer to be always first', js: true do
      within ".answers" do
        within "#answer-id-#{answer.id}" do
          click_on 'Best Answer'
        end
        within "#answer-id-#{another_answer.id}" do
          click_on 'Best Answer'
        end   
        # whithin '.answer:first' do
        #   #use content of the best answer from Factory
        #   to eq answer.body
        # end
        sleep(1)
        answers = page.all('div.answers > div')
      
        expect(answers[0][:class]).to eq 'best-answer'
        expect(page).to have_selector('.best-answer', count: 1)
      end
      
    end
  end

  scenario 'Not an author cannot mark answer to be the best' do
    sign_in(not_author)
    confirm_email(not_author.email)
    sign_in(not_author)

    visit question_path(question)
    expect(page).to_not have_content 'Best Answer'
  end

  scenario 'Non-authenticated user cannot see best answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Best Answer'
  end
end