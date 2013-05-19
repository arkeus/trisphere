class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_user
  
  def set_user
  	if session[:user_id]
  		@user = User.find(session[:user_id])
  		@user.logged_in = true
  		@character = Character.where(user_id: @user.id, active: true).first
  	else
  		@user = User.new
  	end
  end
end
