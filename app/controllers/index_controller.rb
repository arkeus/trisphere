class IndexController < ApplicationController
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
end
