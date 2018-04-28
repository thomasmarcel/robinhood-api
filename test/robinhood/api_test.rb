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
    it 'Must get the user orders' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      orders = robinhood.orders
      assert_equal(Hash, orders.class)
      assert_equal(true, orders.keys.include?('results'))
    end

    it 'Must try to order an option' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      order = robinhood.order('sell', 'AAPL', 200.0, 1, 'market')
      assert_equal(Hash, order.class)
      assert order.keys.include?('results') || order.keys.include?('detail')
    end

    it 'Must try to buy an option' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      order = robinhood.buy('AAPL', 200.0, 1)
      assert_equal(Hash, order.class)
      assert order.keys.include?('results') || order.keys.include?('detail')
    end

    it 'Must try to limit buy an option' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      order = robinhood.limit_buy('AAPL', 200.0, 1)
      assert_equal(Hash, order.class)
      assert order.keys.include?('results') || order.keys.include?('detail')
    end

    it 'Must try to sell an option' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      order = robinhood.sell('AAPL', 200.0, 1)
      assert_equal(Hash, order.class)
      assert order.keys.include?('results') || order.keys.include?('detail')
    end

    it 'Must try to limit sell an option' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      order = robinhood.limit_sell('AAPL', 200.0, 1)
      assert_equal(Hash, order.class)
      assert order.keys.include?('results') || order.keys.include?('detail')
    end

    it 'Must try to stop loss sell of an option' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      order = robinhood.stop_loss_sell('AAPL', 200.0, 1)
      assert_equal(Hash, order.class)
      assert order.keys.include?('results') || order.keys.include?('detail')
    end

    it 'Must try to cancel an order of an option' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      order = robinhood.cancel_order('7A325341-CEEB-4DEC-AE6D-E607B765FB4D')
      assert_equal(Hash, order.class)
      assert order.keys.include?('results') || order.keys.include?('detail')
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
    it 'Must must get the instrument for AAPL by symbol and ID' do
      robinhood = Robinhood::Api.new

      robinhood.login(
        ENV['ROBINHOOD_USERNAME'],
        ENV['ROBINHOOD_PASSWORD']
      )

      instrument = robinhood.instruments('AAPL')
      assert_equal(Hash, instrument.class)
      assert_equal(true, instrument.keys.include?('results'))
      assert_equal(true, instrument['results'][0].keys.include?('symbol'))

      instrument_by_id = robinhood.instruments(instrument['results'][0]['id'])
      assert_equal(Hash, instrument_by_id.class)
      assert_equal(true, instrument_by_id.keys.include?('id'))
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
      assert_equal(Hash, positions.class)
      # TODO: Try to use an instrument based on current positions if any
      # assert_equal(true, positions.keys.include?('results'))
    end
  end

  describe 'General helpers' do
    it 'Must display method list' do
      assert_equal(15, Robinhood::Api.methodlist.length)
    end

    it 'Must flatten hash' do
      example = {
        a: {
          d: 4,
          e: {
            f: 5,
            g: 6
          }
        },
        b: 2,
        c: 3
      }

      assert_equal(
        { d: 4, e: { f: 5, g: 6 }, b: 2, c: 3 },
        Robinhood::Api.flatten(example)
      )
    end

    it 'Must return the id only' do
      assert_equal(
        '450dfc6d-5510-4d40-abfb-f633b7d9be3e',
        Robinhood::Api.strip(
          'https://api.robinhood.com/instruments/450dfc6d-5510-4d40-abfb-f633b7d9be3e/'
        )
      )
    end

    it 'Must fix the hash' do
      example = {
        'instrument' => 'https://api.robinhood.com/instruments/450dfc6d-5510-4d40-abfb-f633b7d9be3e/',
        a: 1,
        b: {
          c: 2,
          d: 3
        }
      }

      assert_equal(
        { 'instrument' => '450dfc6d-5510-4d40-abfb-f633b7d9be3e' },
        Robinhood::Api.fix_hash(example)
      )
    end
  end
end
