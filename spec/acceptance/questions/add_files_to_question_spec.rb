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

  scenario 'User adds file while creating a question' do
    attach_file 'File', ["#{Rails.root}/Gemfile.lock", "#{Rails.root}/Gemfile"]
    click_on 'Create'

    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/files/1/Gemfile.lock'
    expect(page).to have_link 'Gemfile', href: '/uploads/attachment/files/1/Gemfile'
  end
end