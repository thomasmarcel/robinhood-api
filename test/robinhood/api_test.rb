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

  describe 'User Data' do
    it 'Must must get the accounts' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      accounts = robinhood.accounts
      assert_equal(Hash, accounts.class)
      assert_equal(true, accounts.keys.include?('results'))
      assert accounts['results'].length >= 1
    end

    it 'Must must get the investment profile' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      profile = robinhood.investment_profile
      assert_equal(Hash, profile.class)
      assert_equal(true, profile.keys.include?('user'))
    end
  end
end
