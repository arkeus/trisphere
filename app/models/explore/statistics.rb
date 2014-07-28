class Statistics
	VALUES = [:strength, :wisdom, :defense, :agility, :stamina, :spirit]

	attr_accessor(*VALUES)

	def initialize(options)
		VALUES.each do |stat|
			raise "Missing statistic #{stat}" unless options[stat]
			instance_variable_set("@#{stat}", options[stat])
		end
	end
end