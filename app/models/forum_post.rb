class ForumPost < ActiveRecord::Base
	def icon
		return "defense" if self.locked && self.sticky
		return "stamina" if self.locked
		return "strength" if self.sticky
		return "spirit"
	end
end
