class SkillDatabase < MemoryDatabase
	protected
	
	def generate_data
		
	end
	
	private
	
	KNIGHT_ID = 10_00_00
	ROGUE_ID  = 11_00_00
	WIZARD_ID = 12_00_00
	CLERIC_ID = 13_00_00
	ARCHER_ID = 14_00_00
	
	TIER_ID = 10_00
	
	SKILLS = {
		knight: [
			# Tier 1
			[
				{ name: "Slash", description: "Slashes your opponent for increased damage." },
				{ name: "Bash", description: "Bashes your opponent with your weapon, dealing damage and sometimes stunning them." },
			],
			# Tier 2
			[
				{ name: "T2a Knight" },
				{ name: "T2b Knight" },
			]
		],
		rogue: [
			# Tier 1
			[
				{ name: "T1a Rogue" },
				{ name: "T1b Rogue" },
			]
		],
		wizard: [
			# Tier 1
			[
				{ name: "T1a Rogue" },
				{ name: "T1b Rogue" },
			]
		],
		cleric: [
			# Tier 1
			[
				{ name: "T1a Rogue" },
				{ name: "T1b Rogue" },
			]
		],
		archer: [
			# Tier 1
			[
				{ name: "T1a Rogue" },
				{ name: "T1b Rogue" },
			]
		]
	}
end