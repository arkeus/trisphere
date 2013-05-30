require "affix"
require "base_item"
require "item_lib"

class ItemGenerator
	def self.equipment(min_level, max_level, type = nil, subtype = nil, prefix_chance = 0.5, suffix_chance = 0.5)
		base = BaseItem.database.select { |i| i.level >= min_level && i.level <= max_level && (type.nil? || i.type == type) && (subtype.nil? || i.subtype == subtype) }.sample
		item = Item.new
		item.base = base
		item.prefix = Affix.random(Affix::PREFIX) if rand <= prefix_chance
		item.suffix = Affix.random(Affix::SUFFIX) if rand <= suffix_chance
		item
	end
end