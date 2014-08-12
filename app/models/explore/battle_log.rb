class BattleLog
	def initialize
		@messages = []
	end
	
	def add(message)
		@messages << format(message)
	end
	
	def messages
		@messages
	end
	
	# Specific messages
	
	def defeat_enemy(enemy)
		add "You defeated the {enemy}#{enemy.name}{/}"
	end
	
	def gain_experience(experience)
		add "You gain {exp}#{experience}{/} experience"
	end
	
	def find_gold(gold)
		add "You found {gold}#{gold}{/} gold"
	end
	
	def encounter_enemy(enemy)
		add "You encounted a {enemy}#{enemy.name}{/}"
	end
	
	def attack(source, target, weapon, damage)
		case source.type
		when :player then player_attack source, target, weapon, damage
		when :enemy then enemy_attack source, target, weapon, damage
		end
	end
	
	def player_attack(source, target, weapon, damage)
		add "You attack the {enemy}#{target.name}{/} with your {rarity #{weapon[:rarity]}}#{weapon[:name]}{/} for {damage}#{damage}{/} damage"
	end
	
	def enemy_attack(source, target, weapon, damage)
		add "The {enemy}#{source.name}{/} attacks you for {damage}#{damage}{/} damage"
	end
	
	def debug(message)
		add "{debug}#{message}{/}"
	end
	
	private
	
	def format(message)
		message.gsub(/\{(.*?)\}(.*?)\{\/\}/, %q(<strong class="\1">\2</strong>))
	end
end