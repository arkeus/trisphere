require "database"
require "item_lib"

class Affix
	include AffixType, AffixPropertyType
	
	attr_reader :id, :type, :name, :ilevel, :chance, :data
	
	def initialize(id, type, name, ilevel, chance, data = {})
		@id = id
		@type = type
		@name = name
		@ilevel = ilevel
		@chance = chance
		@data = data
	end
	
	def self.find(id)
		item = id.is_a?(Integer) ? DATABASE_MAP[id] : DATABASE_NAME_MAP[id]
		raise "Cannot find affix via '#{id}'" unless item
		item
	end
	
	def self.random(type, chance = 100)
		DATABASE.select { |affix| affix.type == type && affix.chance <= chance }.sample
	end
	
	DATABASE = [
		# Prefixes
		## Common
		### Base Stats
		Affix.new(10_000_0001, PREFIX, "Potent", 1, 100, { strength: [1, 0.6] }),
		Affix.new(10_000_0002, PREFIX, "Mystic", 1, 100, { wisdom: [1, 0.6] }),
		Affix.new(10_000_0003, PREFIX, "Fortified", 1, 100, { defense: [1, 0.6] }),
		Affix.new(10_000_0004, PREFIX, "Quick", 1, 100, { agility: [1, 0.6] }),
		Affix.new(10_000_0005, PREFIX, "Vitalized", 1, 100, { stamina: [1, 0.6] }),
		Affix.new(10_000_0006, PREFIX, "Spiritual", 1, 100, { spirit: [1, 0.6] }),
		# Suffixes
		## Common
		### Base Stats
		Affix.new(20_000_0001, SUFFIX, "of Strength", 1, 100, { strength: [1, 0.6] }),
		Affix.new(20_000_0002, SUFFIX, "of Wisdom", 1, 100, { wisdom: [1, 0.6] }),
		Affix.new(20_000_0003, SUFFIX, "of Defense", 1, 100, { defense: [1, 0.6] }),
		Affix.new(20_000_0004, SUFFIX, "of Agility", 1, 100, { agility: [1, 0.6] }),
		Affix.new(20_000_0005, SUFFIX, "of Stamina", 1, 100, { stamina: [1, 0.6] }),
		Affix.new(20_000_0006, SUFFIX, "of Spirit", 1, 100, { spirit: [1, 0.6] }),
	].freeze
	
	include Database
end