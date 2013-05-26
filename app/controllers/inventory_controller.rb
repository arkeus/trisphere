require "item_generator"
require "item_lib"

class InventoryController < ApplicationController
	def index
		@items = Item.where(character_id: @character.id)
	end
	
	def list
		@items = Item.where(character_id: @character.id)
		render json: @items
	end
	
	def reset
		Item.delete_all
		100.times do
			@item = ItemGenerator.equipment(1, 100)
			@item.character_id = @character.id
			@item.save!
		end
		redirect_to action: :index and return
	end
	
	private
	
	INVENTORY_COLUMNS = ["data"].freeze
end
