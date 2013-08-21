class User < ActiveRecord::Base
	has_secure_password
	
	has_many :friendships
	has_many :friends, through: :friendships, class_name: "User"
	
	after_initialize :init
	attr_writer :logged_in
	
	def init
		@logged_in = false
	end
	
  def logged_in?
    @logged_in
  end
end
