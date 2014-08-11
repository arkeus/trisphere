class Statistics
	include ActiveModel::Serializers::JSON
	
	BASE = [:strength, :wisdom, :defense, :agility, :stamina, :spirit].freeze
	RATINGS = [:accuracy, :exp_rating, :gold_rating, :critical_rating, :critical_power].freeze
	OTHER = [:armor].freeze
	ALL = (BASE + RATINGS + OTHER).flatten.freeze
	ATTRIBUTES = Hash[ALL.map { |stat| [stat, 0] }].freeze
	
	ALL = (BASE + RATINGS + OTHER).freeze

	attr_accessor(*BASE)
	attr_accessor(*RATINGS)
	attr_accessor(*OTHER)

  # Initializes a statistics object from base ratings. All BASE ratings are required.
	def initialize(options)
		BASE.each do |stat|
			raise "Missing statistic #{stat}" unless options[stat]
			set(stat, options[stat])
		end
		RATINGS.each { |rating| set(rating, 0) }
		OTHER.each { |rating| set(rating, 0) }
	end
	
	# Sets the given stat
	def set(stat, value)
		instance_variable_set("@#{stat}", value)
	end
	
	# Gets the given stat
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
	
	# Merges another statistics into this object and sums them
	def merge!(other)
		ALL.each do |key|
			increment(key, other.get(key))
		end
		self
	end
	
	def hp
		20
	end
	
	def mpr
		0
	end
	
	def as_json(options = {})
		serializable_hash(methods: [:hp, :mpr])
	end
	
	def attributes
		ATTRIBUTES
	end
end