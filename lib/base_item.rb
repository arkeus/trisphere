require "database"
require "item_lib"

class BaseItem
	include ItemType, ItemSubtype, Rarity
	
	attr_reader :id, :name, :ilevel, :type, :subtype, :rarity, :chance, :data
	
	def initialize(id, name, ilevel, type, subtype, rarity, chance, data = {})
		@id = id
		@name = name
		@ilevel = ilevel
		@type = type
		@subtype = subtype
		@rarity = rarity
		@chance = chance
		@data = data
	end
	
	def image
		name.gsub(/ /, "_").downcase
	end
	
	def image_path
		"items/#{image}.png"
	end
	
	def effect
		return case type
			when ItemType::WEAPON then [10, 7, 90]
			when ItemType::ARMOR then 5
			else 0
		end
	end
	
	def self.find(id)
		item = id.is_a?(Integer) ? database_map[id] : database_name_map[id]
		raise "Cannot find item via '#{id}'" unless item
		item
	end
	
	def self.database
		BaseItem.build unless defined?(@@database)
		@@database
	end
	
	def self.database_map
		BaseItem.build unless defined?(@@database)
		@@database_map
	end
	
	def self.database_name_map
		BaseItem.build unless defined?(@@database)
		@@database_name_map
	end
	
	def self.build
		return if defined?(@@database)
		@@database = []
		
		# Monster Drop Items
		MonsterDrops::TIERS.each do |tier_id, tier, tier_level|
			MonsterDrops::ITEMS.each do |item_id, name, item_level, type, subtype, data|
				ilevel = tier_level + item_level
				data = data.blank? ? {} : data.inject({}) { |acc, map| acc[map[0]] = map[1].call(ilevel); acc }
				@@database << BaseItem.new(TIER_ID + tier_id + item_id, "#{tier} #{name}", ilevel, type, subtype, COMMON, 100, data)
			end
		end
		
		p "LOG databse length #{@@database.length}"
		
		@@database_map = @@database.inject({}) { |acc, item| acc[item.id] = item; acc }
		@@database_name_map = @@database.inject({}) { |acc, item| acc[item.name] = item; acc }
	end
	
	TIER_ID = 10
	CRAFTING_ID = 11
	
	module MonsterDrops
		include ItemType, ItemSubtype
		
		TIERS = [
			[10_00, "Dwarven", 0],
			[11_00, "Scarab", 10],
			[12_00, "Golem", 20],
			[13_00, "Dryad", 30],
			[14_00, "Demon", 40],
			[15_00, "Elven", 50],
			[16_00, "Titan", 60],
			[17_00, "Dragon", 70],
			[18_00, "Valkyrie", 80],
		].freeze
	
		ITEMS = [
			[22_00_00, "Short Dagger", 1, WEAPON, DAGGER],
			[23_00_00, "Long Dagger", 6, WEAPON, DAGGER],
			[10_00_00, "Short Sword", 1, WEAPON, SWORD],
			[11_00_00, "Long Sword", 3, WEAPON, SWORD],
			[12_00_00, "Broadsword", 6, WEAPON, SWORD],
			[13_00_00, "Bastard Sword", 8, WEAPON, SWORD],
			[14_00_00, "Light Axe", 1, WEAPON, AXE],
			[15_00_00, "Heavy Axe", 3, WEAPON, AXE],
			[16_00_00, "Crescent Axe", 6, WEAPON, AXE],
			[17_00_00, "Battle Axe", 8, WEAPON, AXE],
			[26_00_00, "Short Spear", 1, WEAPON, SPEAR],
			[27_00_00, "Long Spear", 6, WEAPON, SPEAR],
			[18_00_00, "Small Wand", 1, WEAPON, STAFF],
			[19_00_00, "Large Wand", 3, WEAPON, STAFF],
			[20_00_00, "Long Staff", 6, WEAPON, STAFF],
			[21_00_00, "Battle Staff", 8, WEAPON, STAFF],
			[24_00_00, "Light Bow", 1, WEAPON, BOW],
			[25_00_00, "Heavy Bow", 6, WEAPON, BOW],
			
			[50_00_00, "Light Belt", 1, ARMOR, BELT],
			[51_00_00, "Heavy Belt", 6, ARMOR, BELT],
			[52_00_00, "Light Bracers", 1, ARMOR, BRACERS],
			[53_00_00, "Heavy Bracers", 6, ARMOR, BRACERS],
			[54_00_00, "Light Boots", 1, ARMOR, BOOTS],
			[55_00_00, "Heavy Boots", 6, ARMOR, BOOTS],
			[56_00_00, "Small Helmet", 1, ARMOR, HELMET],
			[57_00_00, "Large Helmet", 6, ARMOR, HELMET],
			[58_00_00, "Light Plate", 1, ARMOR, CHESTPIECE],
			[59_00_00, "Heavy Plate", 6, ARMOR, CHESTPIECE],
			[60_00_00, "Light Legplates", 1, ARMOR, LEGPLATES],
			[61_00_00, "Heavy Legplates", 6, ARMOR, LEGPLATES],
			
			[62_00_00, "Ruby Ring", 7, ARMOR, RING,     { strength: -> ilevel { (ilevel / 5).floor * 2 } }],
			[63_00_00, "Sapphire Ring", 7, ARMOR, RING, { wisdom:   -> ilevel { (ilevel / 5).floor * 2 } }],
			[64_00_00, "Emerald Ring", 7, ARMOR, RING,  { defense:  -> ilevel { (ilevel / 5).floor * 2 } }],
			[65_00_00, "Topaz Ring", 7, ARMOR, RING,    { agility:  -> ilevel { (ilevel / 5).floor * 2 } }],
			[66_00_00, "Diamond Ring", 7, ARMOR, RING,  { stamina:  -> ilevel { (ilevel / 5).floor * 2 } }],
			[67_00_00, "Amethyst Ring", 7, ARMOR, RING, { spirit:   -> ilevel { (ilevel / 5).floor * 2 } }],
			[68_00_00, "Amulet", 7, ARMOR, AMULET],
			
			[90_00_00, "Pickaxe", 1, TOOL, PICKAXE],
			[91_00_00, "Hatchet", 1, TOOL, HATCHET],
			[92_00_00, "Spade", 1, TOOL, SPADE],
		].freeze
	end
end