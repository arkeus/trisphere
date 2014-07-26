class Enemy
	attr_accessor :level, :name
	attr_accessor :hp, :mp
	
	def initialize(level, name)
		@level = level
		@name = name
		@hp = 20
		@mp = 20
	end
	
	def self.find
		return Enemy.new 1, "Green Slime"
	end
end