class PropertyHandler
	def handle(value, ilevel)
		value
	end
end

class AffixPropertyHandler < PropertyHandler
	def handle(value, ilevel)
		if value.is_a? Array
			offset, scale = value
			max = scale * ilevel
			min = max * 0.5
			(offset + rand(max - min) + min).ceil
		elsif value.is_a? Integer
			value
		end
	end
end