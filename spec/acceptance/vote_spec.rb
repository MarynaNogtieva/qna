require_relative 'acceptance_helper'

feature 'Votes', '
  In order to help other users identify the best answer/question
  As an authenticated non-author user
  I want to be able to give votes for answers/questopms
' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) {create(:answer, question: question, user: author)}

  scenario 'author cannot vote for his/her question' do
    sign_in(author)
    visit question_path(question)

    within "#question-id-#{question.id}" do
      expect(page).to_not have_css '.vote-up'
      expect(page).to_not have_css '.vote-down'
    end
  end

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
