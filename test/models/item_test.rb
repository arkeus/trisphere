require "test_helper"

class ItemTest < ActiveSupport::TestCase
	setup do
		@base = BaseItem.new(rand_int, "Name", 1, "Weapon", "Sword", "Common", 1, { strength: 5 })
		@prefix = Affix.new(rand_int, "Prefix", "Prefix", 1, 1, { strength: 2, defense: 3 })
		@suffix = Affix.new(rand_int, "Suffix", "Suffix", 1, 1, { strength: 1, wisdom: 10 })
		@nobase = Item.new
		@item = Item.new
		@item.base = @base
	end

	test "require base" do
		assert_raise_message(RuntimeError, "missing base") { @nobase.image_path }
		assert_raise_message(RuntimeError, "missing base") { @nobase.type }
		assert_raise_message(RuntimeError, "missing base") { @nobase.subtype }
		assert_raise_message(RuntimeError, "missing base") { @nobase.effect }
		assert_raise_message(RuntimeError, "missing base") { @nobase.level }
		assert_raise_message(RuntimeError, "missing base") { @nobase.base }
		assert_raise_message(RuntimeError, "missing base for save") { @nobase.save }
	end

	test "name" do
		assert_equal "Name", @item.name
		@item.prefix = @prefix
		assert_equal "Prefix Name", @item.name
		@item.suffix = @suffix
		assert_equal "Prefix Name Suffix", @item.name
	end

	test "no double base" do
		assert_raise(RuntimeError) { @item.base = @base }
	end

	test "no double affix" do
		@item.prefix = @prefix
		assert_raise(RuntimeError) { @item.prefix = @prefix }
		@item.suffix = @suffix
		assert_raise(RuntimeError) { @item.suffix = @suffix }
	end
	
	test "no double affix after find" do
		@item = @nobase
		@item.base = BaseItem.find("Dwarven Broadsword")
		@item.prefix = Affix.find("Potent")
		@item.save!
		retrieved = Item.find(@item.id)
		assert_raise(RuntimeError) { retrieved.prefix = Affix.find("Potent") }
	end

	test "base save and retrieve" do
		@item = @nobase
		@item.base = BaseItem.find("Dwarven Broadsword")
		@item.save!
		retrieved = Item.find(@item.id)
		assert_equal @item.id, retrieved.id
		assert_equal 10_10_12_00, retrieved.base.id
		assert_equal "Dwarven Broadsword", retrieved.name
		assert_equal "Dwarven Broadsword", retrieved.base.name
		assert_equal({}, retrieved.stats)
	end

	test "base save and retrieve by id" do
		@item = @nobase
		@item.base = BaseItem.find(10_10_12_00)
		@item.save!
		retrieved = Item.find(@item.id)
		assert_equal @item.id, retrieved.id
		assert_equal 10_10_12_00, retrieved.base.id
		assert_equal "Dwarven Broadsword", retrieved.name
		assert_equal "Dwarven Broadsword", retrieved.base.name
		assert_equal({}, retrieved.stats)
	end

	test "base save and retrieve with affixes" do
		@item = @nobase
		@item.base = BaseItem.find("Scarab Short Dagger") # Level 11
		@item.prefix = Affix.find("Potent")
		@item.suffix = Affix.find("of Defense")
		@item.save!
		retrieved = Item.find(@item.id)
		assert_equal @item.id, retrieved.id
		assert_equal 10_11_22_00, retrieved.base.id
		assert_equal "Potent Scarab Short Dagger of Defense", retrieved.name
		assert_equal "Scarab Short Dagger", retrieved.base.name
		# 1 + 0.6 * level(11) = max(8), min(5)
		assert_stats({ strength: 6.5, defense: 6.5 }, retrieved.stats, 1.5)
	end

	test "base save and retrieve with affixes by id" do
		@item = @nobase
		@item.base = BaseItem.find(10_11_22_00) # Level 11
		@item.prefix = Affix.find(10_000_0001)
		@item.suffix = Affix.find(20_000_0003)
		@item.save!
		retrieved = Item.find(@item.id)
		assert_equal @item.id, retrieved.id
		assert_equal 10_11_22_00, retrieved.base.id
		assert_equal 10_000_0001, retrieved.prefix.id
		assert_equal 20_000_0003, retrieved.suffix.id
		assert_equal "Potent Scarab Short Dagger of Defense", retrieved.name
		assert_equal "Scarab Short Dagger", retrieved.base.name
		# 1 + 0.6 * level(11) = max(8), min(5)
		assert_stats({ strength: 6.5, defense: 6.5 }, retrieved.stats, 1.5)
	end
	
	test "raise on unable to find" do
		assert_raise(RuntimeError) { BaseItem.find(9999999999) }
		assert_raise(RuntimeError) { Affix.find(999999999) }
		assert_raise(RuntimeError) { BaseItem.find("Invalid Item") }
		assert_raise(RuntimeError) { Affix.find("Invalid Affix") }
	end
	
	test "slot" do
		assert_equal ItemType::WEAPON, Item.new(base: BaseItem.find("Scarab Short Dagger")).slot
		assert_equal ItemType::WEAPON, Item.new(base: BaseItem.find("Scarab Broadsword")).slot
		assert_equal ItemSubtype::BELT, Item.new(base: BaseItem.find("Scarab Light Belt")).slot
		assert_equal ItemSubtype::HELMET, Item.new(base: BaseItem.find("Scarab Large Helmet")).slot
	end
	
	private
	
	def assert_stats(expected, actual, delta)
		assert_equal Set.new(expected.keys), Set.new(actual.keys)
		expected.keys.each do |key|
			assert_in_delta expected[key], actual[key], delta
		end
	end
end
