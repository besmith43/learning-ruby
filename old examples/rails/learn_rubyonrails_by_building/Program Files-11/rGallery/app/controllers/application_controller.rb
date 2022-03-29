class ApplicationController < ActionController::Base
	before_filter :getCategoryNav
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def getCategoryNav
  	@categoryNav = Category.all
  end
end
