class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_filter :set_user
  after_filter :save_user
  
  def set_user
  	if session[:user_id]
  		@user = User.find(session[:user_id])
  		@user.logged_in = true
  		@user.active_at = Time.now
  		@character = Character.where(user_id: @user.id, active: true).first
  	else
  		@user = User.new
  	end
  end
  
  def save_user
  	@user.save! if @user.changed?
  end
end
