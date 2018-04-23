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

  describe 'Portfolio' do
    it 'Must must get the portfolio' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      accounts = robinhood.accounts
      portfolio = robinhood.portfolio(accounts['results'][0]['account_number'])
      assert_equal(Hash, portfolio.class)
      assert_equal(true, portfolio.keys.include?('url'))
    end
  end

  describe 'Instruments and Quotes' do
    it 'Must must get the instrument for AAPL' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      instrument = robinhood.instruments('AAPL')
      assert_equal(Hash, instrument.class)
      assert_equal(true, instrument.keys.include?('results'))
      assert_equal(true, instrument['results'][0].keys.include?('symbol'))
    end

    it 'Must must get the quote for AAPL' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      quote = robinhood.quote('AAPL')
      assert_equal(Hash, quote.class)
      assert_equal(true, quote.keys.include?('symbol'))
    end
  end

  describe 'Positions' do
    it 'Must must get the positions' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      account = robinhood.accounts['results'][0]['account_number']
      positions = robinhood.positions(account)
      assert_equal(Hash, positions.class)
      assert_equal(true, positions.keys.include?('results'))
    end

    it 'Must must get the positions for a specific instrument' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      account = robinhood.accounts['results'][0]['account_number']
      instrument = robinhood.instruments('AAPL')
      positions = robinhood.positions(account, instrument['results'][0]['id'])
      puts positions
      assert_equal(Hash, positions.class)
      # TODO: Try to use an instrument based on current positions if any
      # assert_equal(true, positions.keys.include?('results'))
    end
  end
end
