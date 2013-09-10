class FriendsController < ApplicationController
	def index
		@friendships = @user.friendships.includes(:friend)
		@users = Hash[*@friendships.map { |friend| [friend.friend.id, friend.friend] }.flatten]
	end
end
