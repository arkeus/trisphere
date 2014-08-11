ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_user(params = {})
  	password = SecureRandom.hex
  	user = User.new({
  		username: SecureRandom.hex,
  		password: password,
  		password_confirmation: password,
  		email: SecureRandom.hex,
  	}.merge!(params))
  	user.save!
  	user
  end
  
  def rand_int(min = 1, max = 2 ** 31)
  	rand(min..max)
  end
  
  def assert_raise_message(type, message, &block)
  	error = assert_raise(type, &block)
  	assert_equal message, error.message
  end
end