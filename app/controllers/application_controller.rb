require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    format.js   { head :forbidden }
    format.json { head :forbidden }
    format.html { redirect_to root_path, notice: exception.message }
  end
  
  def gon_user
    gon.current_user_id = current_user.id if current_user
  end 
end
