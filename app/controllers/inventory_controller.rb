require "item_generator"
require "item_lib"

class InventoryController < ApplicationController
	def index
		@item = ItemGenerator.equipment(1, 100, ItemType::ARMOR, ItemSubtype::RING)
		@item2 = ItemGenerator.equipment(1, 100, ItemType::ARMOR, ItemSubtype::RING)
		
		#p "LOG #{BaseItem.database_map}"
	end
end
