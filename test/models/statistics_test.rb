require "test_helper"

class StatisticsTest < ActiveSupport::TestCase
	test "require all base stats to create" do
		assert_raise(RuntimeError) { Statistics.new(strength: 1) }
		assert_raise(RuntimeError) { Statistics.new(strength: 1, agility: 1, stamina: 1) }
		assert_not_nil Statistics.new(strength: 1, wisdom: 1, defense: 1, agility: 1, stamina: 1, spirit: 1)
	end
	
	test "initialize" do
		statistics = Statistics.new(strength: 1, wisdom: 2, defense: 3, agility: 4, stamina: 5, spirit: 6)
		assert_equal 1, statistics.strength
		assert_equal 2, statistics.wisdom
		assert_equal 3, statistics.defense
		assert_equal 4, statistics.agility
		assert_equal 5, statistics.stamina
		assert_equal 6, statistics.spirit
		assert_equal 0, statistics.gold_rating
	end
	
	test "empty" do
		statistics = Statistics.empty
		assert_equal 0, statistics.strength
		assert_equal 0, statistics.wisdom
		assert_equal 0, statistics.defense
		assert_equal 0, statistics.agility
		assert_equal 0, statistics.stamina
		assert_equal 0, statistics.spirit
		assert_not_equal Statistics.empty, statistics
	end
	
	test "increment base" do
		statistics = Statistics.empty
		statistics.increment :strength, 1
		assert_equal 1, statistics.strength
		statistics.increment :strength, 2
		assert_equal 3, statistics.strength
		statistics.increment :strength, 3
		assert_equal 6, statistics.strength
		statistics.increment :defense, 1
		assert_equal 1, statistics.defense
	end
	
	test "increment rating" do
		statistics = Statistics.empty
		assert_equal 0, statistics.accuracy
		statistics.increment :accuracy, 1
		assert_equal 1, statistics.accuracy
		statistics.increment :accuracy, 1
		assert_equal 2, statistics.accuracy
	end
	
	test "merge" do
		stats1 = Statistics.empty
		stats1.set(:strength, 1)
		stats1.set(:defense, 2)
		
		stats2 = Statistics.empty
		stats2.set(:defense, 1)
		stats2.set(:gold_rating, 2)
		
		stats1.merge! stats2
		assert_equal 0, stats1.get(:wisdom)
		assert_equal 1, stats1.get(:strength)
		assert_equal 3, stats1.get(:defense)
		assert_equal 2, stats1.get(:gold_rating)
	end
end
