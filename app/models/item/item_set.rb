class ItemSet
	attr_accessor :stats
	
	def initialize(items)
		@stats = Statistics.empty
		items.each { |item| add item }
	end
	
	def stat(name)
		@stats.get(name)
	end
	
	private
	
	def add(item)
		item.stats.each do |stat, value|
			@stats.increment stat, value
		end
		@stats.increment :armor, item.armor
	end
end