class User < ActiveRecord::Base
	has_secure_password
	
	has_many :friendships
	has_many :friends, through: :friendships, class_name: "User"
	
	after_initialize :init
	before_save :before_save
	attr_writer :logged_in
	
	def init
		@logged_in = false
	end
	
	# Returns whether this user is authenticated within the current request to be logged in.
  def logged_in?
    @logged_in
  end
  
  # Returns whether this user is online or not. Threshold: Action taken within the last 5 minutes.
  def online?
  	self.active_at && self.active_at > 5.minutes.ago
  end
  
  # Adds a friend to this user's friendlist with an optional note.
  def befriend(user, note = nil)
    raise "Expected 'User' class, got '#{user.class}'" unless user.is_a?(User)
    raise "Cannote add friend, '#{user.username}' is already a friend!" if friendships.find { |u| u.friend_id == user.id }
    Friendship.create(user_id: self.id, friend_id: user.id, note: note)
  end
  
  # Removes a friend from this user's friendlist.
  def unfriend(user)
    friends.delete(user)
  end
  
  # Edits the note of a user who is already on this user's friendlist.
  def set_friend_note(user, note)
    raise "Expected 'User' class, got '#{user.class}'" unless user.is_a?(User)
    friendship = friendships.find { |u| u.friend_id == user.id }
    raise "Could not find friend '#{user.username}'" unless friendship
    friendship.note = note
    friendship.save!
  end
  
  # Initializes any values that need to be set before save.
  def before_save
  	self.active_at ||= Time.now if new_record?
  end
  
  # The string representation of a user is the username.
  def to_s
  	self.username
  end
end
