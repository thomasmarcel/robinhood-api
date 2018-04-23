require 'test_helper'
# require 'pry'

class RobinhoodApiTest < Minitest::Test
  describe 'Login' do
    it 'Must fail login' do
      robinhood = Robinhood::Api.new

      login = robinhood.login('aaa', 'bbb')
      assert_equal(
        'Unable to log in with provided credentials.',
        login['non_field_errors'][0]
      )
    end

    it 'Must successfully login' do
      robinhood = Robinhood::Api.new

      login = robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )
      assert_equal(String, login.class)
      assert_equal(40, login.length)
    end
  end

  describe 'Orders' do
    it 'Must must get the user orders' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      orders = robinhood.orders
      assert_equal(Hash, orders.class)
      assert_equal(true, orders.keys.include?('results'))
    end
  end
end
