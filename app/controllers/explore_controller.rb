class ExploreController < ApplicationController
	def index
		
	end
	
	def explore
		render json: Enemy.find
	end
	
	def player
		render json: @character
	end
end
