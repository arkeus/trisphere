class ItemSet
	attr_accessor :stats
	
	def initialize(items)
		@stats = Statistics.empty
		items.each { |item| add item }
	end
	
	def stat(name)
		@stats
	end
	
	private
	
	def add(item)
		item.stats do |stat, value|
			@stats.increment stat, value
		end
	end
end