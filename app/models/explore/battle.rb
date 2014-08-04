class Battle < ActiveRecord::Base
	serialize :player, Battler
	serialize :enemy, Battler
	
	attr_accessor :rewards
	
	def setup!(log)
		@log = log
		@log.encounter_enemy enemy
	end
	
	def process!(log)
		@log = log
		process_player
		process_enemy
		post_process
	end
	
	def complete?
		return player.hp <= 0 || enemy.hp <= 0
	end
	
	private 
	
	def process_player
		player.attack enemy, @log
		enemy.hp -= 10
	end
	
	def process_enemy
		enemy.attack player, @log
		player.hp -= 5
	end
	
	def post_process
		return unless complete?
		
		@rewards = { gold: 4, xp: 17, items: [] }
		
		@log.defeat_enemy enemy
		@log.gain_experience 17
		@log.find_gold 4
	end
end
