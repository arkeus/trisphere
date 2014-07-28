class BattleLog
	def initialize
		@messages = []
	end
	
	def add(message)
		@messages << message
	end
	
	def raw_messages
		@messages
	end
	
	def formatted_messages
		@messages
	end
end