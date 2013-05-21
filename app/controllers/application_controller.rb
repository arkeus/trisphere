class ApplicationController < ActionController::Base
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
