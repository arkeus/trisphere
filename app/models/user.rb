class User < ActiveRecord::Base
	has_secure_password
	
	after_initialize :init
	attr_writer :logged_in
	
	def init
		@logged_in = false
	end
	
  def logged_in?
    @logged_in
  end
end
