class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_omni_auth, only: %i[facebook twitter sign_up]

  def facebook; end

  def twitter; end

  def sign_up
    session[:auth] = nil
  end

  def sign_in_omni_auth
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Welcome! #{@user.email}. You are logged in successfully"
      # set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format? #check if it's the right format(i.e.: html)
    else
      set_flash_message(:notice, :error, kind: 'Facebook') if is_navigational_format? 
      flash[:notice] = 'Email is required to finish registration'
      session[:auth] = { uid: auth.uid, provider: auth.provider }
      render 'common/confirm_mail', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params_auth)
  end

  def params_auth
    session[:auth] ? params[:auth].merge(session[:auth]) : params[:auth]
  end
end