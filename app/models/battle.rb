class Battle < ActiveRecord::Base
	serialize :player, Battler
	serialize :enemy, Battler
	
	def process!
		player.hp -= 1
		enemy.hp -= 2
	end
	
	def complete?
		return player.hp <= 0 || enemy.hp <= 0
	end
end
