require_relative '../acceptance_helper'


feature 'Add files to answer', '
In order to illustreate my answer
As an author of the answer
I want to be able to attach files to it' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your Answer', with: 'Answer test for the test question'
  end

  scenario 'An authenticated user tries to attach files to the answer he is creating', js: true do
    attach_file 'File', "#{Rails.root}/README.md"
    click_on 'Answer a question'
    within '.answers' do
      expect(page).to have_link 'README.md', href: '/uploads/attachment/file/1/README.md'
    end
  end

  scenario 'An authenticated user tries to attach more than one file to the answer he/she is creating', js: true do
    attach_file 'File', "#{Rails.root}/README.md"
    click_on 'add more file'
    click_on 'add more file'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/Gemfile.lock")
    inputs[1].set("#{Rails.root}/Gemfile")
   
    click_on 'Answer a question'
    wait_for_ajax

    expect(page).to have_content 'README.md'
    expect(page).to have_content 'Gemfile.lock'
    expect(page).to have_content 'Gemfile'
  end
end