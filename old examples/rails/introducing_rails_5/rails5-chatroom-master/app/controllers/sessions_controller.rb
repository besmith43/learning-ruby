class SessionsController < ApplicationController
  before_action :authenticate, except: [:new, :create]

  def new
  end

  def create
    if user.try(:authenticate, params[:password])
      session[:current_user] = user.id
      cookies.signed[:user_id] ||= user.id
      redirect_to root_url
    else
      redirect_to login_url
    end
  end

  def destroy
    session[:current_user] = nil
    cookies.signed[:user_id] = nil
    redirect_to login_url
  end

  private

  def user
    @user ||= User.find_by_email(params[:email])
  end
end
