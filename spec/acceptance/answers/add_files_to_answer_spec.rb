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

  scenario 'An authenticated user tries to attach one file to the answer he is creating', js: true do
    attach_file 'File', "#{Rails.root}/README.md"
    click_on 'Answer a question'
    within '[id^="answer-id-"] > ul' do
      expect(page).to have_link 'README.md', href: '/uploads/attachment/files/1/README.md'
    end
  end

  scenario 'An authenticated user tries to attach more than one file to the answer he is creating', js: true do
    attach_file 'File', ["#{Rails.root}/Gemfile.lock", "#{Rails.root}/Gemfile"]
    click_on 'Answer a question'
    sleep(3)
    within '[id^="answer-id-"] > ul' do
      expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/files/1/Gemfile.lock'
      expect(page).to have_link 'Gemfile', href: '/uploads/attachment/files/1/Gemfile'
    end
  end
end