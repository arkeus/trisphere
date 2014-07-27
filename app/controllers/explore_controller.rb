class ExploreController < ApplicationController
	def index
		@character_battler = @character.as_json(only: [:name, :level, :hp, :hpm, :mp, :mpm])
	end
	
	def explore
		render json: Enemy.find
	end
	
	def attack
		battle = Battle.find_by user_id: @user.id
		raise "Not in battle" unless battle
		
		battle.process!
		battle.save!
		
		render json: { battle: battle.as_json, messages: ["something here"] }
	end
end
