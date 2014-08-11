require "test_helper"

class ItemSetTest < ActiveSupport::TestCase
	test "cannot initialize with null items" do 
		assert_raise(NoMethodError) { ItemSet.new nil }
	end
	
	test "initialize" do
		is = ItemSet.new []
		Statistics::BASE.each { |base| assert_equal 0, is.stats.get(base) }
	end
	
	test "single item" do
		i1 = create_item("i1", { strength: 2, defense: 1 })
		assert_equal 2, i1.stats[:strength]
		is = ItemSet.new [i1]
		assert_equal 2, is.stat(:strength)
		assert_equal 1, is.stat(:defense)
		assert_equal 0, is.stat(:wisdom)
	end
	
	private
	
	def create_item(name, data)
		base = BaseItem.new(rand_int, "name", 1, "Weapon", "Sword", "Common", 1, data)
		item = Item.new
		item.base = base
		item
	end
end