module Robinhood
  # The API module instance methods for ordering (buy and sell)
  module ApiModule
    def investment_profile
      raw_response = HTTParty.get(
        endpoints[:investment_profile], headers: headers
      )
      JSON.parse(raw_response.body)
    end

    def accounts
      raw_response = HTTParty.get(endpoints[:accounts], headers: headers)
      JSON.parse(raw_response.body)
    end

    def portfolio(account_number)
      raw_response = HTTParty.get(
        "https://api.robinhood.com/accounts/#{account_number}/portfolio/",
        headers: headers
      )
      JSON.parse(raw_response.body)
    end
  end
end
