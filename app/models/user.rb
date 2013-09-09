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
  
  def befriend(user, note = nil)
    raise "Expected 'User' class, got '#{user.class}'" unless user.is_a?(User)
    Friendship.create(user_id: self.id, friend_id: user.id, note: note)
  end
  
  def unfriend(user)
    friends.delete(user)
  end
  
  def set_friend_note(user, note)
    raise "Expected 'User' class, got '#{user.class}'" unless user.is_a?(User)
    friendship = friendships.find { |u| u.friend_id == user.id }
    raise "Could not find friend '#{user.username}'" unless friendship
    friendship.note = note
    friendship.save!
  end
end
