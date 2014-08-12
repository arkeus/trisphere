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
		@log = log
		@log.debug "#{type} ->"
		weapon_attack target
	end
	
	private
	
	def weapon_attack(target)
		critical = roll_critical target
		damage = calculate_weapon_damage target, critical
		target.hp -= damage
		@log.attack self, target, { name: @weapon, rarity: @weapon_rarity }, damage, critical
	end
	
	def calculate_weapon_damage(target, critical)
		damage = @weapon_damage
		difference = (@stats.get(:strength) - target.stats.get(:defense)) / 50.0
		@log.debug "Strength #{@stats.get(:strength)} Defense #{target.stats.get(:defense)} Difference #{difference} Base Damage #{damage}"
		damage += @stats.get(:strength) / 4.0
		if difference > 0
			damage *= 1 + difference
		else
			damage /= (-1 + difference).abs
		end
		damage *= 1.5 if critical
		damage = damage.ceil
		@log.debug "Adjusted damage #{damage}"
		damage
	end
	
	def skill_attack(target)
		
	end
	
	def calculate_skill_damage(target)
		
	end
	
	def roll_critical(target)
		chance = 5
		difference = @stats.get(:agility) - target.stats.get(:agility)
		@log.debug "Difference is #{difference}"
		if difference > 0
			chance = chance + difference
		else
			chance /= (1 + difference.abs / 5)
			chance = [1, chance].max
		end
		@log.debug "Critical chance #{chance}%"
		(rand * 100) <= chance
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