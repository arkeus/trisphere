require "test_helper"

class MemoryDatabaseTest < ActiveSupport::TestCase
	setup do
		@@db ||= TestDatabase.new
	end
	
	test "size" do
		assert_equal 4, @@db.size
	end
	
	test "find by id" do
		assert_equal "Red", @@db.find(1).name
		assert_equal "Green", @@db.find(2).name
		assert_equal "Blue", @@db.find(3).name
		assert_equal "Yellow", @@db.find(4).name
	end
	
	test "find by name" do
		assert_equal 1, @@db.find("Red").id
		assert_equal 2, @@db.find("Green").id
		assert_equal 3, @@db.find("Blue").id
		assert_equal 4, @@db.find("Yellow").id
	end
	
	test "can't find" do
		assert_raise(RuntimeError) { @@db.find(5) }
		assert_raise(RuntimeError) { @@db.find("Purple") }
	end
	
	test "raise on invalid model" do
		assert_raise(RuntimeError) { InvalidDatabase.new }
	end
	
	class TestDatabase < MemoryDatabase
		protected
		
		def generate_data
			data = []
			data << TestModel.new(1, "Red")
			data << TestModel.new(2, "Green")
			data << TestModel.new(3, "Blue")
			data << TestModel.new(4, "Yellow")
			data
		end
	end
	
	class TestModel
		attr_reader :id, :name
		
		def initialize(id, name)
			@id = id
			@name = name
		end
	end
	
	class InvalidDatabase < MemoryDatabase
		protected
		
		def generate_data
			["whatever"]
		end
	end
end