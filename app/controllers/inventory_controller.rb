require "item_generator"
require "item_lib"

class InventoryController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	# GET /
	def index
		items = Item.unequipped(@character)
	end
	
	# GET /bags
	def bags
		items = Item.unequipped(@character)
		render json: items
	end
	
	# GET /equipped
	def equipped
		items = Item.equipped(@character)
		render json: items
	end
	
	# GET /stats
	def stats
		render json: { stats: @character.full_stats }
	end
	
	# POST /equip
	# { id: <int> }
	def equip
		id = required(:id)
		
		item = Item.find(id)
		render status: :forbidden and return unless item
		render status: :forbidden and return unless item.character_id == @character.id
		render status: :forbidden and return unless item.equippable?
		render status: :bad_request and return if item.equipped
		
		equipped_set = Item.where(character_id: @character.id, equipped: true)
		equipped_set.each do |es|
			next unless es.slot == item.slot
			es.unequip
			es.save!
		end
		
		item.equip
		item.save!
		
		render json: { stats: @character.full_stats }
	end
	
	# POST /unequip
	# { id: <int> }
	def unequip
		id = required(:id)
		item = Item.find(id)
		render status: :forbidden and return unless item
		render status: :forbidden and return unless item.character_id == @character.id
		render status: :forbidden and return unless item.equippable?
		render status: :bad_request and return unless item.equipped
		
		item.unequip
		item.save!
		
		render json: { stats: @character.full_stats }
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
