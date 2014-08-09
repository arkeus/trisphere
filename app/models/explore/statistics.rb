class Statistics
	BASE = [:strength, :wisdom, :defense, :agility, :stamina, :spirit].freeze
	RATINGS = [:accuracy, :exp_rating, :gold_rating, :critical_rating, :critical_power].freeze

	attr_accessor(*BASE)
	attr_accessor(*RATINGS)

	def initialize(options)
		BASE.each do |stat|
			raise "Missing statistic #{stat}" unless options[stat]
			instance_variable_set("@#{stat}", options[stat])
		end
	end
	
	def get(name)
		instance_variable_get("@#{name}") || 0
	end
	
	# Creates a new statistics object with all base values at 0
	def self.empty
		Statistics.new Hash[BASE.map { |base| [base, 0] }]
	end
	
	# Increments a stat by the given value
	def increment(stat, value)
		current = instance_variable_get("@#{stat}") || 0
		instance_variable_set("@#{stat}", current + value)
	end
end