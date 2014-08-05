class ExploreController < ApplicationController
	def index
		@character_battler = @character.as_json(only: [:name, :level, :hp, :hpm, :mp, :mpm])
	end
	
	def explore
		battle = Battle.find_by user_id: @user.id
		log = BattleLog.new
		
		if battle
			log.add "You returned to your battle with #{battle.enemy.name}"
		else
			player = Battler.new @character
			enemy = Battler.new Enemy.find
			battle = Battle.new user_id: @user.id, player: player, enemy: enemy
			battle.setup! log
			battle.save!
		end
		
		render json: { battle: battle.as_json, messages: log.messages }
	end
	
	def attack
		battle = Battle.find_by user_id: @user.id
		raise "Not in battle" unless battle
		
		log = BattleLog.new
		battle.process! log
		update = nil
		
		if battle.complete?
		  update = handle_rewards battle.rewards
			battle.destroy
		else
			battle.save!
		end
		
		render json: { battle: battle.as_json, messages: log.messages, complete: battle.complete?, update: update }
	end
	
	private
	
	def handle_rewards(rewards)
		@user.gain_gold rewards[:gold] if rewards[:gold]
		@character.gain_xp rewards[:xp] if rewards[:xp]
		{ gold: @user.gold, level: @character.level, xp: @character.xp, xpm: @character.xpm }
	end
end
