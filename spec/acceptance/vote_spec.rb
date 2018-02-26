require_relative 'acceptance_helper'

feature 'Votes', '
  In order to help other users identify the best answer/question
  As an authenticated non-author user
  I want to be able to give votes for answers/questions
' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) {create(:answer, question: question, user: author)}

  scenario 'author cannot vote for his/her question' do
    sign_in(author)
    visit question_path(question)

    within "#question-id-#{question.id}" do
      expect(page).to_not have_css '.vote-for'
      expect(page).to_not have_css '.vote-against'
    end
  end

  scenario 'author cannot vote for his/her answer' do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_css '.vote-for'
      expect(page).to_not have_css '.vote-against'
    end
  end
  
  describe 'Question' do
    scenario 'non-author votes the question up', js: true do
      sign_in(user)
      visit question_path(question)

      within "#question-id-#{question.id}" do
        within '.vote' do
          click_on '+'
          expect(page).to have_content 1
        end
      end
    end

    scenario 'non-author votes the question  down', js: true do
      sign_in(user)
      visit question_path(question)

      within "#question-id-#{question.id}" do
        within '.vote' do
          click_on '-'
          expect(page).to have_content -1
        end
      end
    end

    scenario 'non-author resets the vote for question', js: true do
      sign_in(user)
      visit question_path(question)

      within "#question-id-#{question.id}" do
        within '.vote' do
          click_on '-'
          click_on 'Reset Vote'
          expect(page).to have_content 0
        end
      end
    end
  end

  describe 'Answer vote' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'non-author votes the answer up', js: true do
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          click_on '+'
          expect(page).to have_content 1
        end
      end
    end

    scenario 'non-author votes the answer  down', js: true do
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          click_on '-'
          expect(page).to have_content -1
        end
      end
    end

    scenario 'non-author resets the vote for answer', js: true do
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          click_on '+'
          click_on 'Reset Vote'

          expect(page).to have_content 0

          click_on '-'
          click_on 'Reset Vote'

          expect(page).to have_content 0
        end
      end
    end
    scenario 'non-author cannot vote for/against answer twice', js: true do
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          click_on '+'
          expect(page).to_not have_css '.vote-for'
          expect(page).to_not have_css '.vote-against'
        end
      end
    end

    scenario 'all users can see the score', js: true do
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          expect(page).to have_css '.vote-score'
        end
      end
    end
  end
end
