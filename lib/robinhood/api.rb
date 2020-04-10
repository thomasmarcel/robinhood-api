require 'date'

module Robinhood
  # The API module check for methods that require login.
  module ApiModule
    # Your code goes here...
    def self.before(*names)
      names.each do |name|
        m = instance_method(name)
        define_method(name) do |*args, &block|
          if token_compliant?(name)
            m.bind(self).call(*args, &block)
          else
            puts 'You have to run the login(<username>, <password>) method ' \
              "or a Robinhood.new instance before running the #{name} method"
            exit 1
          end
        end
      end
    end
  end

  # The API module instance methods
  module ApiModule
    require 'httparty'
    require 'json'

    require_relative './api/accounts'
    require_relative './api/orders'

    include HTTParty

    attr_accessor :errors

    def initialize; end

    def login(username, password, mfa_code = nil)
      raw_response = HTTParty.post(
        endpoints[:login],
        body: payload(username, password, mfa_code),
        headers: headers
      )
      response = JSON.parse(raw_response.body)
      if response['access_token']
        token_type = response['token_type']
        response = response['access_token']
        @headers['Authorization'] = "#{token_type} #{response}"
      end
      response
    end

    def payload(username, password, mfa_code = nil, expires_in = 86400, scope = 'internal')
      client_id = "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS"
      body = {
        'client_id': client_id,
        'expires_in': expires_in,
        'grant_type': 'password',
        'password': password,
        'scope': scope,
        'username': username,
        'challenge_type': 'sms', # 'email'
        'device_token': generate_device_token
      }
      body['mfa_code'] = mfa_code unless mfa_code.nil?
      body
    end

    def instruments(symbol)
      if symbol.include?('-')
        raw_response = HTTParty.get(
          "#{endpoints[:instruments]}#{symbol}/", headers: headers
        )
      else
        raw_response = HTTParty.get(
          endpoints[:instruments],
          query: { 'query' => symbol.upcase },
          headers: headers
        )
      end

      JSON.parse(raw_response.body)
    end

    def quote(symbol)
      raw_response = HTTParty.get(
        "https://api.robinhood.com/quotes/#{symbol}/",
        headers: headers
      )
      JSON.parse(raw_response.body)
    end

    def positions(account_number, instrument_id = nil)
      url = "https://api.robinhood.com/positions/?nonzero=true"
      url = "#{url}/#{instrument_id}/" if instrument_id
      raw_response = HTTParty.get(url, headers: headers)
      JSON.parse(raw_response.body)
    end

    def dividends()
      raw_response = HTTParty.get(endpoints[:dividends], headers: headers)
      JSON.parse(raw_response.body)
    end

    def url(url)
      raw_response = HTTParty.get(url, headers: headers)
      JSON.parse(raw_response.body)
    end

    private

    def endpoints
      # return api_url + "/oauth2/token/"
      {
        login:  'https://api.robinhood.com/oauth2/token/',
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

    def headers
      @headers ||= {
        'Accept' => 'application/json'
      }
    end

    def token_compliant?(method)
      if methodlist.include?(method)
        if headers.key?('Authorization')
          true
        else
          false
        end
      else
        true
      end
    end

    ##
    # This function will generate a token used when loggin on.
    # :returns: A string representing the token.
    ##
    def generate_device_token()
      rands = []
      (0...16).each do |i|
        r = Random.rand()
        rand = 4294967296.0 * r
        rands << ((rand.to_i >> ((3 & i) << 3)) & 255)
      end

      hexa = []
      (0...256).each do |i|
        hexa << ((i + 256).to_s(16))[1..-1]
      end

      id = ""
      (0...16).each do |i|
        id += hexa[rands[i]]
        id += "-" if i == 3 || i == 5 || i == 7 || i == 9
      end

      id
    end
  end

  # Robinhood API's class methods
  class Api
    include ApiModule

    def self.methodlist
      %i[investment_profile accounts ach_iav_auth ach_relationships
         ach_transfers applications dividends edocuments margin_upgrade
         notifications orders password_reset document_requests user watchlists]
    end

    def self.flatten(var)
      new_var = {}
      var.each do |k, v|
        if v.class == Hash
          v.each do |l, w|
            new_var[l] = w
          end
        else
          new_var[k] = v
        end
      end
      new_var
    end

    def self.sanitize(var)
      var.delete('updated_at') if var.keys.include?('updated_at')

      var.delete('created_at') if var.keys.include?('created_at')

      new_var = {}
      var.each do |k, v|
        key = k
        key = 'object_type' if key == 'type'
        key = 'third_party_id' if key == 'id'
        if v.class == String
          if v.include?('T') && v.include?('Z')
            begin
              new_var[key] = Time.parse(v)
            rescue StandardError
              new_var[key] = v
            end
          else
            begin
              new_var[key] = Float(v)
            rescue StandardError
              new_var[key] = v
            end
          end
        end
      end
      new_var
    end

    def self.strip(str)
      str.split('/').last
    end

    def self.fix(var)
      if var.class == Hash
        fix_hash(var)
      elsif var.class == Array
        arr = []
        var.each do |ha|
          arr << fix_hash(ha)
        end
        arr
      end
    end

    def self.fix_hash(var)
      instance = var.clone
      instance = flatten(instance)
      instance = sanitize(instance)
      keys = %w[account instrument position quote market fundamentals]
      keys.each do |key|
        instance[key] = strip(instance[key]) if instance.key?(key)
      end

      instance
    end
  end
end
