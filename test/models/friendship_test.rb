require 'test_helper'

class FriendTest < ActiveSupport::TestCase
	test "users begin with no friends" do
		user = create_user
		assert user.friends.empty?
	end
	
	test "create a friend" do
		user1 = create_user
		user2 = create_user
		user1.befriend(user2)
		assert_equal 1, user1.friends.size
		assert_equal 1, Friendship.count
		assert_equal 0, user2.friends.size
	end
	
	test "user adds multiple friends" do
		user1 = create_user
		user2 = create_user
		user3 = create_user
		user1.befriend(user2)
		user1.befriend(user3)
		
		friends = user1.friends.map(&:username)
		assert_equal 2, friends.size
		assert user2.username.in?(friends)
		assert user3.username.in?(friends)
		
		friendships = Friendship.all
		assert_equal [user2.id, user3.id], friendships.map(&:friend_id)
		assert_equal [user1.id, user1.id], friendships.map(&:user_id)
	end
	
	test "cannot add non-users to friends" do
		user = create_user
		assert_raise(RuntimeError) { user.befriend(1) }
		assert_raise(RuntimeError) { user.befriend("bob") }
	end
	
	test "unfriend" do
		user1 = create_user
		user2 = create_user
		user3 = create_user
		user1.befriend(user2)
		user1.befriend(user3)
		
		friends = user1.friends.map(&:username)
		assert_equal 2, friends.size
		assert user2.username.in?(friends)
		assert user3.username.in?(friends)
		
		user1.unfriend(user2)
		
		friends = user1.friends.map(&:username)
		assert_equal 1, friends.size
		assert !user2.username.in?(friends)
		assert user3.username.in?(friends)
		
		user1.unfriend(user3)
		
		friends = user1.friends.map(&:username)
		assert_equal 0, friends.size
		assert !user2.username.in?(friends)
		assert !user3.username.in?(friends)
		
		assert_equal 0, Friendship.count
		assert_equal 3, User.count, "Removing friends shouldn't delete user"
	end
	
	test "set friend note" do
		user1 = create_user
		user2 = create_user
		user3 = create_user
		user1.befriend(user2)
		user1.befriend(user3, "note")
		
		assert_equal nil, Friendship.find(1).note
		assert_equal "note", Friendship.find(2).note
		
		user1.set_friend_note(user2, "note2")
		user1.set_friend_note(user3, nil)
		
		assert_equal "note2", Friendship.find(1).note
		assert_equal nil, Friendship.find(2).note
	end
end
