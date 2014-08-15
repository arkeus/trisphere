require "base_item"
require "affix"
require "item_lib"
require "property_handler"

# Example of use:
#   item = Item.new
#   item.base = base_object
#   item.prefix = prefix_object
#   item.character_id = 1
#   item.save
class Item < ActiveRecord::Base
	serialize :data, Hash
	
	after_find :after_find
	before_save :before_save
	
	def name
		"#{prefix.name + " " if prefix}#{base.name}#{" " + suffix.name if suffix}"
	end
	
	def image_path
		base.image_path
	end
	
	def type
		base.type
	end
	
	def subtype
		base.subtype
	end
	
	def effect
		base.effect
	end
	
	def level
		base.level
	end
	
	def price
		150
	end
	
	def rarity
		value = 0
		value += 1 if prefix
		value += 1 if suffix
		return case value
			when 0 then Rarity::COMMON
			when 1 then Rarity::UNCOMMON
			when 2 then Rarity::RARE
		end
	end
	
	def base
		raise "missing base" unless @base
		@base
	end
	
	def prefix
		@prefix
	end
	
	def suffix
		@suffix
	end
	
	def stats
		self.data ||= {}
	end
	
	def armor
		return 0 if type != ItemType::ARMOR
		base.armor
	end
	
	def weapon_damage
		return 0 if type != ItemType::WEAPON
		base.weapon_damage
	end
	
	def magic_damage
		return 0 if type != ItemType::WEAPON
		base.magic_damage
	end
	
	def accuracy
		return 0 if type != ItemType::WEAPON
		base.accuracy
	end
	
	def base=(base)
		raise "Item already has base" if @base
		@base = base
		merge_stats!(stats, base.data, PROPERTY_HANDLER)
	end
	
	def prefix=(prefix)
		raise "Item already has prefix" if @prefix
		@prefix = prefix
		merge_stats!(stats, prefix.data, AFFIX_PROPERTY_HANDLER)
	end
	
	def suffix=(suffix)
		raise "Item already has suffix" if @suffix
		@suffix = suffix
		merge_stats!(stats, suffix.data, AFFIX_PROPERTY_HANDLER)
	end
	
	def self.from_name(name)
		Item.new(base_id: BaseItem.find(name).id)
	end
	
	def self.from_id(id)
		Item.new(base_id: BaseItem.find(id).id)
	end
	
	def as_json(options = {})
		super(:only => [:data, :id, :equipped], :methods => [:name, :image_path, :type, :subtype, :rarity, :effect, :level, :price])
	end
	
	def equippable?
		base.equippable?
	end
	
	def equip
		self.equipped = true
	end
	
	def unequip
		self.equipped = false
	end
	
	def slot
		return case type
		 when ItemType::WEAPON then type
		 when ItemType::ARMOR then subtype
		 else nil
		end
	end
	
	def give(character)
		self.character_id = character.id
		save!
	end
	
	# finders
	
	def self.equipped(character)
		where(character_id: character.id, equipped: true)
	end
	
	def self.unequipped(character)
		where(character_id: character.id, equipped: false)
	end
	
	private
	
	def merge_stats!(stats, merge, property_handler)
		merge.each do |key, value|
			value = property_handler.handle(value, self.base.level)
			if stats[key]
				stats[key] += value
			else
				stats[key] = value
			end
		end
	end
	
	def before_save
		raise "missing base for save" unless @base
		self.base_id = @base.id
		self.prefix_id = @prefix.id if @prefix
		self.suffix_id = @suffix.id if @suffix
	end
	
	def after_find
		raise "missing base after find" unless base_id
		@base = BaseItem.find(base_id)
		@prefix = Affix.find(prefix_id) if prefix_id
		@suffix = Affix.find(suffix_id) if suffix_id
	end
	
	PROPERTY_HANDLER = PropertyHandler.new
	AFFIX_PROPERTY_HANDLER = AffixPropertyHandler.new
end
