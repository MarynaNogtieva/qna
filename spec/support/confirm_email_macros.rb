module ConfirmEmailMacros
  def confirm_email(email)
    click_on "Didn't receive confirmation instructions?"
    fill_in 'Email', with: email
    click_on 'Resend confirmation instructions'
    open_email(email)
   
    current_email.click_link 'Confirm my account'  
  end
end