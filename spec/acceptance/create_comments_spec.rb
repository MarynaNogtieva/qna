require_relative 'acceptance_helper'

feature 'Create comment', '
In order to help someone to solve somebodies problem or clarify something
As an authenticated user
I want to be able to create comments for answer and/or question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'An authenticated user tries to create comment for a question', js: true do
    sign_in(user)
    visit question_path(question)
    
   create_question_comment
  end

  scenario 'An authenticated user tries to create comment for an answer', js: true do
    sign_in(user)
    visit question_path(question)
    
    create_answer_comment
  end

  context 'multiple sessions' do
    scenario "comments for question and answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        create_question_comment
        sleep(5)
        create_answer_comment
        sleep(5)
      end

      Capybara.using_session('guest') do
        within '.question-wrap' do
          expect(page).to have_content 'A comment for a question'
        end
        within "#answer-id-#{answer.id}" do
          expect(page).to have_content 'A comment for an answer'
        end
      end
    end
  end

  def create_answer_comment
    within "#answer-id-#{answer.id}" do
      fill_in 'comment_body', with: 'A comment for an answer'
      click_on 'Place a comment'
      within '.all-comments' do
        expect(page).to have_content 'A comment for an answer'
      end
    end
  end

  def create_question_comment
    within '.question-wrap' do
      fill_in 'comment_body', with: 'A comment for a question'
      click_on 'Place a comment'
      within '.all-comments' do
        expect(page).to have_content 'A comment for a question'
      end
    end
  end
end