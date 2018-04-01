require_relative '../acceptance_helper'



feature 'Edit question', '
In order to fix some errors or typos in a question
as a user and an its author
I want to be able to edit the question
' do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) {create(:question, user: author)}

  scenario 'A non-authenticated user cannot see edit link' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'An authenticated user' do
    scenario 'Not an author cannot see edit link' do
      sign_in(not_author)
      confirm_email(not_author.email)
      sign_in(not_author)

      visit question_path(question)
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
    scenario 'Author can see edit link' do 
      sign_in(author)
      confirm_email(author.email)
      sign_in(author)

      visit question_path(question)
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end
    scenario 'Author tries edit his/her question with valid params', js: true do
      sign_in(author)
      confirm_email(author.email)
      sign_in(author)
      visit question_path(question)

      within '.question' do
        click_on 'Edit Question'
        fill_in 'Title', with: 'edited title'
        fill_in 'Question', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea#question_body'
      end
    end

    scenario 'Author tries to upload files while editing a question', js: true do
      sign_in(author)
      confirm_email(author.email)
      sign_in(author)
      visit question_path(question)

      add_files_to_question

      expect(page).to have_content 'Gemfile.lock'
      expect(page).to have_content 'Gemfile'
    end

    scenario 'Author tries to delete files while editing his/her answer', js: true do
      sign_in(author)
      confirm_email(author.email)
      sign_in(author)
      visit question_path(question)
      add_files_to_question
      click_on 'Edit Question'

      within '.edit-question' do
        all('.remove_fields.existing').each(&:click)
        click_on 'Save'
      end
      expect(page).to_not have_content 'Attachments:'
      expect(page).to_not have_content 'Gemfile.lock'
      expect(page).to_not have_content 'Gemfile'
    end
  end

  def add_files_to_question
    click_on 'Edit Question'
      fill_in 'Title', with: 'edited title'
      fill_in 'Question', with: 'edited question'
      within '.edit-question' do
        click_on 'add file'
        click_on 'add file'
        inputs = all('input[type="file"]')
        inputs[0].set("#{Rails.root}/Gemfile.lock")
        inputs[1].set("#{Rails.root}/Gemfile")
        click_on 'Save'
      end
  end
end
