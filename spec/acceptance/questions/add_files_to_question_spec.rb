require_relative '../acceptance_helper'


feature 'Add files to question', '
In order to illustreate my question
As an author of the question
I want to be able to attach files to it' do
given(:user) { create (:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
  end

  scenario 'User adds file while creating a question', js: true do
    attach_file 'File', "#{Rails.root}/README.md"
    click_on 'Create'
    expect(page).to have_link 'README.md', href: '/uploads/attachment/file/1/README.md'
  end
  
  scenario 'User adds more than one file while creating a question', js: true do
    click_on 'add more file'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/Gemfile.lock")
    inputs[1].set("#{Rails.root}/Gemfile")
    click_on 'Create'

    expect(page).to have_content 'Gemfile.lock'
    expect(page).to have_content 'Gemfile'
  end
end