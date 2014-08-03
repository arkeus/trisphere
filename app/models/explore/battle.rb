class Battle < ActiveRecord::Base
	serialize :player, Battler
	serialize :enemy, Battler
	
	def setup!(log)
		@log = log
		@log.add "You encountered a #{enemy.name}"
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
		enemy.hp -= 10
		@log.add "You attack the #{enemy.name} for 10 damage"
	end
	
	def process_enemy
		player.hp -= 5
		@log.add "The #{enemy.name} attacks you for 5 damage"
	end
	
	def post_process
		return unless complete?
		
		@log.add "You defeated the #{enemy.name}"
		@log.add "You gained 17 experience"
		@log.add "You found 4 gold"
		
		@log.defeat_enemy enemy
		@log.gain_experience 17
		@log.find_gold 4
	end
end
