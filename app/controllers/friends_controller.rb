class FriendsController < ApplicationController
	def index
		@friendships = @user.friendships.includes(:friend).sort_by { |f| f.friend.active_at }.reverse!
		@users = Hash[*@friendships.map { |friend| [friend.friend.id, friend.friend] }.flatten]
	end
	
	def add
		username = params[:username].to_s
		note = params[:note]
		user = User.where(username: username).first
		raise "Unknown user: #{username}" unless user
		@user.befriend(user, note)
		flash[:info] = "#{username} is now your friend"
		redirect_to :friends and return
	rescue => e
		flash[:error] = e.message
		redirect_to :friends and return
	end
	
	def remove
		username = params[:username].to_s
		user = User.where(username: username).first
		@user.unfriend(user)
		flash[:info] = "You have removed #{username} from your friends list"
		redirect_to :friends and return
	end
end
