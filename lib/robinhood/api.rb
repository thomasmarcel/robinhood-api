require 'date'

module Robinhood
  module ApiModule
    # Your code goes here...
    def self.before(*names)
      names.each do |name|
        m = instance_method(name)
        define_method(name) do |*args, &block|  
          if token_compliant?(name)
            m.bind(self).(*args, &block)
          else
            puts "You have to run the login(<username>, <password>) method or a Robinhood.new instance before running the #{name} method"
            exit 1
          end
        end
      end
    end
  end

  module ApiModule
    require 'httparty'
    require 'json'

    include HTTParty

    attr_accessor :errors

    def initialize
    end

    def login(username, password)
      raw_response = HTTParty.post(
        endpoints[:login],
        body: {
          'password' => password,
          'username'=> username
        },
        headers: headers
      )
      response = JSON.parse(raw_response.body)
      if response['token']
        response = response['token']
        @headers['Authorization'] = "Token #{response}"
      end
      return response
    end

    def investment_profile
      raw_response = HTTParty.get(endpoints[:investment_profile], headers: headers)
      JSON.parse(raw_response.body)
    end

    def orders(order_id=nil)
      url = order_id ? "#{endpoints[:orders]}#{order_id}" : endpoints[:orders]
      raw_response = HTTParty.get(url, headers: headers)
      JSON.parse(raw_response.body)
    end

    def accounts
      raw_response = HTTParty.get(endpoints[:accounts], headers: headers)
      JSON.parse(raw_response.body)
    end

    def portfolio(account_number)
      raw_response = HTTParty.get("https://api.robinhood.com/accounts/#{account_number}/portfolio/", headers: headers)
      JSON.parse(raw_response.body)
    end

    def instruments(symbol)
      if symbol.include?('-')
        raw_response = HTTParty.get("#{endpoints[:instruments]}#{symbol}/", headers: headers)
      else
        raw_response = HTTParty.get(endpoints[:instruments], query: {'query' => symbol.upcase}, headers: headers)
      end

      JSON.parse(raw_response.body)
    end

    def quote(symbol)
      raw_response = HTTParty.get("https://api.robinhood.com/quotes/#{symbol}/", headers: headers)
      JSON.parse(raw_response.body)
    end

    def buy(account_number, symbol, instrument_id, price, quantity)
      raw_response = HTTParty.post(
        endpoints[:orders],
        body: {
          'account' => "https://api.robinhood.com/accounts/#{account_number}/",
          'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
          'price' => price,
          'quantity' => quantity,
          'side' => "buy",
          'symbol' => symbol,
          'time_in_force' => 'gfd',
          'trigger' => 'immediate',
          'type' => 'market'
        },
        headers: headers
      )

      JSON.parse(raw_response.body)
    end

    def limit_buy(account_number, symbol, instrument_id, price, quantity)
      raw_response = HTTParty.post(
        endpoints[:orders],
        body: {
          'account' => "https://api.robinhood.com/accounts/#{account_number}/",
          'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
          'price' => price,
          'quantity' => quantity,
          'side' => "buy",
          'symbol' => symbol,
          'time_in_force' => 'gfd',
          'trigger' => 'immediate',
          'type' => 'limit'
        }.to_json,
        headers: headers
      )

      JSON.parse(raw_response.body)
    end

    def sell(account_number, symbol, instrument_id, price, quantity)
      raw_response = HTTParty.post(
        endpoints[:orders],
        body: {
          'account' => "https://api.robinhood.com/accounts/#{account_number}/",
          'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
          'price' => price,
          'quantity' => quantity,
          'side' => "sell",
          'symbol' => symbol,
          'time_in_force' => 'gfd',
          'trigger' => 'immediate',
          'type' => 'market'
        },
        headers: headers
      )

      JSON.parse(raw_response.body)
    end

    def limit_sell(account_number, symbol, instrument_id, price, quantity)
      raw_response = HTTParty.post(
        endpoints[:orders],
        body: {
          'account' => "https://api.robinhood.com/accounts/#{account_number}/",
          'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
          'price' => price,
          'quantity' => quantity,
          'side' => "sell",
          'symbol' => symbol,
          'time_in_force' => 'gfd',
          'trigger' => 'immediate',
          'type' => 'limit'
        }.to_json,
        headers: headers
      )

      JSON.parse(raw_response.body)
    end

    def stop_loss_sell(account_number, symbol, instrument_id, price, quantity)
      raw_response = HTTParty.post(
        endpoints[:orders],
        body: {
          'account' => "https://api.robinhood.com/accounts/#{account_number}/",
          'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
          'stop_price' => price,
          'quantity' => quantity,
          'side' => "sell",
          'symbol' => symbol,
          'time_in_force' => 'gtc',
          'trigger' => 'stop',
          'type' => 'market'
        }.to_json,
        headers: headers
      )

      JSON.parse(raw_response.body)
    end

    def cancel_order(order_id)
      raw_response = HTTParty.post("https://api.robinhood.com/orders/#{order_id}/cancel/", headers: headers)
      raw_response.code == 200
    end

    def positions(account_number, instrument_id = nil)
      url = "https://api.robinhood.com/accounts/#{account_number}/positions"
      if instrument_id
        url = "#{url}/#{instrument_id}/"
      end
      raw_response = HTTParty.get(url, headers: headers)
      JSON.parse(raw_response.body)
    end

    private

    def endpoints
      {
        login:  'https://api.robinhood.com/api-token-auth/',
        investment_profile: 'https://api.robinhood.com/user/investment_profile/',
        accounts: 'https://api.robinhood.com/accounts/',
        ach_iav_auth: 'https://api.robinhood.com/ach/iav/auth/',
        ach_relationships:  'https://api.robinhood.com/ach/relationships/',
        ach_transfers: 'https://api.robinhood.com/ach/transfers/',
        applications: 'https://api.robinhood.com/applications/',
        dividends:  'https://api.robinhood.com/dividends/',
        edocuments: 'https://api.robinhood.com/documents/',
        instruments:  'https://api.robinhood.com/instruments/',
        margin_upgrade:  'https://api.robinhood.com/margin/upgrades/',
        markets:  'https://api.robinhood.com/markets/',
        notifications:  'https://api.robinhood.com/notifications/',
        orders: 'https://api.robinhood.com/orders/',
        password_reset: 'https://api.robinhood.com/password_reset/request/',
        quotes: 'https://api.robinhood.com/quotes/',
        document_requests:  'https://api.robinhood.com/upload/document_requests/',
        user: 'https://api.robinhood.com/user/',
        watchlists: 'https://api.robinhood.com/watchlists/'
      }
    end

    def methodlist
      [:investment_profile, :accounts, :ach_iav_auth, :ach_relationships, :ach_transfers, :applications, :dividends, :edocuments, :margin_upgrade, :notifications, :orders, :password_reset, :document_requests, :user, :watchlists]
    end

    def headers
      @headers ||= {
        'Accept' => 'application/json',
      }
    end

    def token_compliant?(method)

      if methodlist.include?(method)
        if headers.key?('Authorization')
          return true
        else
          return false
        end
      else
        return true
      end
    end

    before(*instance_methods) { puts "start" }
  end

  class Api
    include ApiModule

    def self.flatten(h)
      new_h = {}
      h.each do |k, v|
        if v.class == Hash
          v.each do |l, w|
            new_h[l] = w
          end
        else
          new_h[k] = v
        end
      end
      new_h
    end

    def self.sanitize(h)
      if h.keys.include?('updated_at')
        h.delete('updated_at')
      end

      if h.keys.include?('created_at')
        h.delete('created_at')
      end

      new_h = {}
      h.each do |k, v|
        key = k
        if key == 'type'
          key = 'object_type'
        end
        if key == 'id'
          key = 'third_party_id'
        end
        if v.class == String
          if v.include?('T') and v.include?('Z')
            begin
              new_h[key] = DateTime.parse(v)
            rescue
              new_h[key] = v
            end
          else
            begin
              new_h[key] = Float(v)
            rescue
              new_h[key] = v
            end
          end
        end
      end
      new_h
    end

    def self.strip(s)
      return s.split('/').last
    end

    def self.fix(h)
      if h.class == Hash
        return self.fix_hash(h)
      elsif h.class == Array
        arr = []
        h.each do |ha|
          arr << self.fix_hash(ha)
        end
        return arr
      else
        return nil
      end
    end

    def self.fix_hash(h)
      instance = h.clone
      instance = self.flatten(instance)
      instance = self.sanitize(instance)
      keys = ['account', 'instrument', 'position', 'quote', 'market', 'fundamentals']
      keys.each do |key|
        instance[key] = self.strip(instance[key]) if instance.key?(key)
      end

      return instance
    end
  end
end
