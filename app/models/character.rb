class Character < ActiveRecord::Base
	def stats
		{ strength: strength, wisdom: wisdom, defense: defense, agility: agility, stamina: stamina, spirit: spirit }
	end
	
	def to_sidebar_json
		to_json only: [:energy, :fatigue, :level, :xp, :xpm]
	end
	
	def gain_xp(xp_gain)
		self.xp += xp_gain
		while self.xp >= self.xpm
			self.level += 1
			self.xp -= self.xpm
			self.xpm = calculate_xpm
		end
	end
	
	def full_stats
		items = equipped_items
		stats = Statistics.new self.stats
		ItemSet.new(items).stats.merge!(stats)
	end
	
	def equipped_items
		@equipped_items ||= Item.equipped(self)
	end
	
	def skills
		[{
			id: 1,
			name: "Leafo Moon Power",
			description: "Moon healing escalation.",
			image: "items/dragon_amulet.png"
		}, {
			id: 2,
			name: "Leafo Crescent Beam",
			description: "Mars star power.",
			image: "items/demon_amulet.png"
		}]
	end
	
	private
	
	def calculate_xpm
		50 #100 + 10 * self.level
	end
end
