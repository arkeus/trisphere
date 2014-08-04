require "statistics" # Force load before deserialization

class Battler
	attr_accessor :level, :name, :type
	attr_accessor :hp, :hpm, :mp, :mpm
	attr_accessor :stats
	
	def initialize(source)
		case source
		when Character then set_character(source)
		when Enemy then set_enemy(source)
		end
	end
	
	def attack(target, log)
		damage = 10
		target.hp -= damage
		log.attack self, target, damage
	end
	
	private

	def set_character(character)
		@level = character.level
		@name = character.name
		@hp = character.hp
		@hpm = character.hpm
		@mp = character.mp
		@mpm = character.mpm
		@stats = Statistics.new character.stats
		@type = :player
	end

	def set_enemy(enemy)
		@level = enemy.level
		@name = enemy.name
		@hp = @hpm = 20
		@mp = @mpm = 20
		@stats = Statistics.new enemy.stats
		@type = :enemy
	end
end