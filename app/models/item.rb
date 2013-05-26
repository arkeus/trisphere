require "base_item"
require "affix"
require "property_handler"

class Item < ActiveRecord::Base
	serialize :data, Hash
	
	def name
		"#{prefix.name + " " if prefix_id}#{base.name}#{" " + suffix.name if suffix_id}"
	end
	
	def image_path
		base.image_path
	end
	
	def base
		raise "Item is missing base" unless base_id
		BaseItem.find(base_id)
	end
	
	def prefix
		Affix.find(prefix_id)
	end
	
	def suffix
		Affix.find(suffix_id)
	end
	
	def stats
		self.data ||= {}
	end
	
	def base=(base)
		self.base_id = base.id
		merge_stats!(stats, base.data, PROPERTY_HANDLER)
	end
	
	def prefix=(prefix)
		self.prefix_id = prefix.id
		merge_stats!(stats, prefix.data, AFFIX_PROPERTY_HANDLER)
	end
	
	def suffix=(suffix)
		self.suffix_id = suffix.id
		merge_stats!(stats, suffix.data, AFFIX_PROPERTY_HANDLER)
	end
	
	def self.from_name(name)
		Item.new(base_id: BaseItem.find(name).id)
	end
	
	def self.from_id(id)
		Item.new(base_id: BaseItem.find(id).id)
	end
	
	def as_json(options = {})
		super(:only => [:data], :methods => [:name, :image_path])
	end
	
	private
	
	def merge_stats!(stats, merge, property_handler)
		merge.each do |key, value|
			value = property_handler.handle(value, self.base.ilevel)
			if stats[key]
				stats[key] += value
			else
				stats[key] = value
			end
		end
	end
	
	PROPERTY_HANDLER = PropertyHandler.new
	AFFIX_PROPERTY_HANDLER = AffixPropertyHandler.new
end
