class IndexController < ApplicationController
	before_filter :redirect_if_logged_in, :except => [:logout]
	
	def index; end
	
	def login
		user = User.find_by_username(params[:username]).try(:authenticate, params[:password])
		if user
			session[:user_id] = user.id
			redirect_to controller: :character, action: :home and return
		else
			flash[:error] = "Invalid username or password"
			redirect_to action: :index and return
		end
	end
	
	def logout
		reset_session
		redirect_to action: :index and return
	end
	
	private
	
	def redirect_if_logged_in
		redirect_to "/character" if @user.logged_in?
	end
end
