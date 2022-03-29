class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  
  protected
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :t_number, :college, :department, :rank, :rank_date, :tenure_date, :email, :password) }
      devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password) }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :t_number, :college, :department, :rank, :rank_date, :tenure_date, :email, :password, :password_confirmation, :current_password) }
  end
  
end
