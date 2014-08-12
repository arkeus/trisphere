require "statistics" # Force load before deserialization

class Battler
	attr_accessor :level, :name, :type
	attr_accessor :hp, :hpm, :mp, :mpm
	attr_accessor :stats
	attr_accessor :weapon, :weapon_rarity, :weapon_damage, :magic_damage, :weapon_accuracy
	
	def initialize(source)
		case source
		when Character then set_character(source)
		when Enemy then set_enemy(source)
		end
	end
	
	def attack(target, log)
		weapon_attack target, log
	end
	
	private
	
	def weapon_attack(target, log)
		damage = calculate_weapon_damage target, log
		target.hp -= damage
		log.attack self, target, { name: @weapon, rarity: @weapon_rarity }, damage
	end
	
	def calculate_weapon_damage(target, log)
		damage = @weapon_damage
		difference = (@stats.get(:strength) - target.stats.get(:defense)) / 50.0
		log.debug "Strength #{@stats.get(:strength)} Defense #{target.stats.get(:defense)} Difference #{difference} Base Damage #{damage}"
		damage += @stats.get(:strength) / 4.0
		if difference > 0
			damage *= 1 + difference
		else
			damage /= (-1 + difference).abs
		end
		damage = damage.ceil
		log.debug "Adjusted damage #{damage}"
		damage
	end

	def set_character(character)
		@level = character.level
		@name = character.name
		@mp = 0
		@mpm = character.mpm
		@stats = character.full_stats
		@hp = @stats.hp
		@hpm = @hp
		@type = :player
		
		items = character.equipped_items
		weapon = items.find { |item| item.type == ItemType::WEAPON }
		if weapon
			@weapon = weapon.name
			@weapon_damage = weapon.weapon_damage
			@magic_damage = weapon.magic_damage
			@weapon_rarity = weapon.rarity
			@weapon_accuracy = weapon.accuracy
		else 
			@weapon = "Fists"
			@weapon_damage = 1
			@magic_damage = 1
			@weapon_rarity = "Common"
			@weapon_accuracy = 80
		end
	end

	def set_enemy(enemy)
		@level = enemy.level
		@name = enemy.name
		@mp = 0
		@mpm = 20
		@hp = @hpm = 20
		@stats = Statistics.new enemy.stats
		@type = :enemy
		@weapon = nil
		@weapon_damage = 5
		@magic_damage = 5
		@weapon_rarity = "Common"
		@weapon_accuracy = 90
	end
end