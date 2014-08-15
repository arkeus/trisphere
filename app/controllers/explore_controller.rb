class ExploreController < ApplicationController
	def index
		@character_battler = @character.as_json(only: [:name, :level, :hp, :hpm, :mp, :mpm], methods: [:skills])
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
		handle_attack do |battle, log|
			battle.process! log
		end
	end
	
	def skill
		id = required(:id)
		
		handle_attack do |battle, log|
			battle.process! log
			log.add "Really should be skill #{id}"
		end
	end
	
	private
	
	def handle_attack
		battle = Battle.find_by user_id: @user.id
		raise "Not in battle" unless battle
		
		log = BattleLog.new
		yield battle, log
		
		if battle.complete?
		  update = handle_rewards battle.rewards
			battle.destroy
		else
			battle.save!
		end
		
		render json: { battle: battle.as_json, messages: log.messages, complete: battle.complete?, update: update }
	end
	
	def handle_rewards(rewards)
		@user.gain_gold rewards[:gold] if rewards[:gold]
		@character.gain_xp rewards[:xp] if rewards[:xp]
		(rewards[:items] || []).each { |item| item.give @character }
		
		{
			user: {
				gold: @user.gold,
			},
			character: {
				level: @character.level,
				xp: @character.xp,
				xpm: @character.xpm,
			}
		}
	end
end
