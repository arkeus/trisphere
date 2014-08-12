require "statistics" # Force load before deserialization

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
	
	def attack(source, target, weapon, damage, critical)
		case source.type
		when :player then player_attack source, target, weapon, damage, critical
		when :enemy then enemy_attack source, target, weapon, damage, critical
		end
	end
	
	def player_attack(source, target, weapon, damage, critical)
		type = critical ? "{critical}critically hit{/}" : "attack"
		add "You #{type} the {enemy}#{target.name}{/} with your {rarity #{weapon[:rarity]}}#{weapon[:name]}{/} for {damage}#{damage}{/} damage"
	end
	
	def enemy_attack(source, target, weapon, damage, critical)
		type = critical ? "{critical}critically hits{/}" : "attacks"
		add "The {enemy}#{source.name}{/} #{type} you for {damage}#{damage}{/} damage"
	end
	
	def debug(message)
		add "{debug}#{message}{/}"
	end
	
	private
	
	def format(message)
		message.gsub(/\{(.*?)\}(.*?)\{\/\}/, %q(<strong class="\1">\2</strong>))
	end
end