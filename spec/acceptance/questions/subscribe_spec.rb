require_relative '../acceptance_helper'

feature 'Subscriptions', %q{
  In order to view information related to a certain question
  As an autenfication user
  I want to subsribe to it
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Non-Autorized user try subsribe to question' do
    visit question_path(question)
    
    expect(page).to_not have_content 'Subscribe'
  end

  scenario 'Author can see an unsubscribe link in his question', js: true do
    sign_in(author)
    confirm_email(author.email)
    sign_in(author)
    create_question
    visit question_path(question)
 
    expect(page).to have_css "input[type=\"submit\"][value=\"Unsubscribe\"]"
 
  end

  describe 'Non-author of question user' do
    before do
      sign_in(user)
      confirm_email(user.email)
      sign_in(user)
      visit question_path(question)
    end

    scenario 'view a subsribe button to foreign question', js: true do
      within '.subscription' do
        expect(page).to have_css "input[type=\"submit\"][value=\"Subscribe\"]"
      end
    end

    scenario 'view unsubscribe button if user is already subscribed to the question', js: true do
      within '.subscription' do
        click_on 'Subscribe'
        expect(page).to have_css "input[type=\"submit\"][value=\"Unsubscribe\"]"
      end
    end
  end


  def create_question
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'
    sleep(2)
  end
end
