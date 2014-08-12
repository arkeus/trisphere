require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
	setup do
		@character = Character.create!(user_id: rand_int, active: true, name: rand_int.to_s)
	end
	
  test "default no equipped items" do
  	items = @character.equipped_items
  	assert_equal 0, items.length
  end
  
  test "equipped items" do
  	i1 = Item.new(base: BaseItem.find("Dwarven Broadsword"), character_id: @character.id)
  	i2 = Item.new(base: BaseItem.find("Dwarven Large Helmet"), character_id: @character.id)
  	i1.equip
  	i2.equip
  	i1.save!
  	i2.save!
  	items = @character.equipped_items
  	assert_equal 2, items.length
  end
  
  test "equipped items cache" do
  	i1 = Item.new(base: BaseItem.find("Dwarven Broadsword"), character_id: @character.id)
  	i2 = Item.new(base: BaseItem.find("Dwarven Large Helmet"), character_id: @character.id)
  	i1.save!
  	i2.save!
  	items = @character.equipped_items
  	assert_equal 0, items.length
  	i1.equip
  	i2.equip
  	i1.save!
  	i2.save!
  	items = @character.equipped_items
  	assert_equal 0, items.length
  end
end
