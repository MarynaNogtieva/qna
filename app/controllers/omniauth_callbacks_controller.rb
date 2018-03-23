class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_omni_auth, only: %i[facebook twitter sign_up]

  def facebook; end

  def twitter; end

  def sign_up
  end

  def sign_in_omni_auth
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format? #check if it's the right format(i.e.: html)
    else
      set_flash_message(:notice, :error, kind: 'Facebook') if is_navigational_format? 
      flash[:notice] = 'Email is required to finish registration'
      render 'common/confirm_mail', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end
end