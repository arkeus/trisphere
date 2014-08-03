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
	
	private
	
	def format(message)
		message.gsub(/\{(.*?)\}(.*?)\{\/\}/, %q(<em class="\1">\2</em>))
	end
	
	def em(klass, message)
		
	end
end