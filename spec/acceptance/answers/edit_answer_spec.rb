require_relative '../acceptance_helper'

feature 'Edit answer', '
In order to fix some error in my answer
As an author of the answer 
I want to be able to edit it.
' do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'A non-authenticated user cannot see edit link' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
  scenario 'Not an author cannot see edit link' do
    sign_in(not_author)

    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'An authenticated user and an author of the answer' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'Author can see edit link' do 
      expect(page).to have_link 'Edit Answer'
    end

    scenario 'Author tries edit his/her answer with valid params', js: true do
      # sleep(1000)
      within ".answers" do
        click_on 'Edit Answer'
        expect(page).to have_css "#edit-answer-#{answer.id}"
      

        within "#edit_answer_#{answer.id}" do 
          # fill_in 'Body', with: 'edited answer'
          fill_in '#answer_body', with: 'edited answer'
          click_on 'Save'
        end

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Author tries edit his/her answer with invalid params' do
      within ".answers" do
        click_on 'Edit Answer'
        expect(page).to have_css "#edit-answer-#{answer.id}"
      end

      within "#edit-answer-#{answer.id}" do 
        fill_in 'Body', with: ''
        click_on 'Save'
      end
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
    end
  end
end