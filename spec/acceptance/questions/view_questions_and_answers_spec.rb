require_relative '../acceptance_helper'

feature 'View list of questions', '
In order to find a solution or if my question was asked before
As a user
I want to be able to view list of questions' do

  given(:user) { create(:user) }
  given(:question) {create(:question, user: user)}
  given!(:questions) { create_list(:question, 5, user: user) }
  given!(:answers) { create_list(:answer, 2, user: user, question: question) }

  scenario 'User can view a list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'User can see a list of answers to a question' do
    visit question_path(question)
    
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
