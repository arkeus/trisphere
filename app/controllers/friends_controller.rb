class FriendsController < ApplicationController
	def index
		@friendships = @user.friendships.includes(:friend)
	end
end
