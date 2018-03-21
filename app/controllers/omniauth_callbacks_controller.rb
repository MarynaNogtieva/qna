class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    sign_in_omni_auth    
  end

  def sign_in_omni_auth
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format? #check if it's the right format(i.e.: html)
    else
      set_flash_message(:notice, :error, kind: 'Facebook') if is_navigational_format? 
    end
  end
end