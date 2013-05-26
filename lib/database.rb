module Database
	def self.included(base)
		base.const_set :DATABASE_MAP, base.const_get(:DATABASE).inject({}) { |acc, item| acc[item.id] = item; acc }
		base.const_set :DATABASE_NAME_MAP, base.const_get(:DATABASE).inject({}) { |acc, item| acc[item.name] = item; acc }
	end
end