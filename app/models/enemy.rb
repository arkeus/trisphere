class Enemy
	attr_accessor :level, :name
	attr_accessor :hp, :mp
	
	def initialize(level, name)
		@level = level
		@name = name
		@hp = 20
		@mp = 20
	end
	
	def stats
		{ strength: 5, wisdom: 5, defense: 5, agility: 5, stamina: 5, spirit: 5 }
	end
	
	def self.find
		return Enemy.new 1, "Green Slime"
	end
end