class Character < ActiveRecord::Base
	def stats
		{ strength: strength, wisdom: wisdom, defense: defense, agility: agility, stamina: stamina, spirit: spirit }
	end
end
