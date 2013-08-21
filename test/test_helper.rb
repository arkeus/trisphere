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
  	return User.create!({
  		username: SecureRandom.hex,
  		password: password,
  		password_confirmation: password,
  		email: SecureRandom.hex,
  	}.merge!(params))
  end
end