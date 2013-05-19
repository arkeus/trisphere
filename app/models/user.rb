class User < ActiveRecord::Base
	has_secure_password
	
  def logged_in?
    false
  end
end
