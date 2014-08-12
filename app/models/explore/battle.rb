require "statistics" # Force load before deserialization

class Battle < ActiveRecord::Base
	serialize :player, Battler
	serialize :enemy, Battler
	
	attr_accessor :rewards
	
	# Sets up a battle before the first turn
	def setup!(log)
		@log = log
		@log.encounter_enemy enemy
	end
	
	# Processes a single turn in the battle
	def process!(log)
		@log = log
		process_player
		process_enemy
		post_process
	end
	
	# Returns whether or not the battle is over
	def complete?
		return player.hp <= 0 || enemy.hp <= 0
	end
	
	private 
	
	# Processes the player's attack this turn
	def process_player
		player.attack enemy, @log
		enemy.hp -= 10
	end
	
	# Processes the enemy's attack this turn
	def process_enemy
		enemy.attack player, @log
		player.hp -= 5
	end
	
	# Runs processing that only occurs after the last turn of a battle
	def post_process
		return unless complete?
		
		@rewards = { gold: 4, xp: 17, items: [] }
		
		@log.defeat_enemy enemy
		@log.gain_experience 17
		@log.find_gold 4
	end
end
