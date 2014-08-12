class EquipmentHelper
	WEAPON_DAMAGE_MULTIPLIER = {
		"Dagger" => 0.9,
		"Sword" => 1.0,
		"Axe" => 1.1,
		"Spear" => 0.8,
		"Wand" => 0.7,
		"Staff" => 0.7,
		"Bow" => 0.9,
	}.freeze
	
	MAGIC_DAMAGE_MULTIPLIER = {
		"Dagger" => 1.0,
		"Sword" => 0.9,
		"Axe" => 0.7,
		"Spear" => 0.8,
		"Wand" => 1.0,
		"Staff" => 1.1,
		"Bow" => 0.8,
	}.freeze
	
	ACCURACY_MAP = {
		"Dagger" => 95,
		"Sword" => 90,
		"Axe" => 80,
		"Spear" => 100,
		"Wand" => 95,
		"Staff" => 90,
		"Bow" => 95,
	}
	
	def self.weapon_damage(level, subtype)
		((level + (level / 2) ** 1.5) * WEAPON_DAMAGE_MULTIPLIER[subtype]).ceil
	end
	
	def self.magic_damage(level, subtype)
		(((level / 2) ** 1.3) * MAGIC_DAMAGE_MULTIPLIER[subtype]).ceil
	end
	
	def self.accuracy(level, subtype)
		ACCURACY_MAP[subtype]
	end
	
	def self.armor(level, subtype)
		(level * 5).ceil
	end
end