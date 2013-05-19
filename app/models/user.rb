class User < ActiveRecord::Base
	has_secure_password
	
	attr_writer :logged_in
	
	def initialize
		@logged_in = false
	end
	
  def logged_in?
    @logged_in
  end
end
