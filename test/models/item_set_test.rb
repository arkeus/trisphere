require "test_helper"

class ItemSetTest < ActiveSupport::TestCase
	test "cannot initialize with null items" do 
		assert_raise(RuntimeError) { ItemSet.new nil }
	end
	
	test "initialize" do
		is = ItemSet.new []
		Statistics::BASE.each { |base| assert_equal 0, is.stats.get(base) }
	end
end