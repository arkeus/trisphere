class MemoryDatabase
	def initialize
		@data = validate generate_data.freeze
		@id_map = @data.inject({}) { |acc, entry| acc[entry.id] = entry; acc }
		@name_map = @data.inject({}) { |acc, entry| acc[entry.name] = entry; acc }
	end
	
	def find(target)
		entry = target.is_a?(Integer) ? @id_map[target] : @name_map[target]
		raise "Cannot find memory database entry via '#{target}'" unless entry
		entry
	end
	
	def size
		@data.size
	end
	
	protected
	
	def generate_data
		raise "Memory databases must implement generate_data"
	end
	
	private
	
	def validate(data)
		data.each do |entry|
			raise "MemoryDatabase entries must respond to id" unless entry.respond_to? :id
			raise "MemoryDatabase entries must respond to name" unless entry.respond_to? :name
		end
	end
end