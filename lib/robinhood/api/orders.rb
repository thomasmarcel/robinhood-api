module Robinhood
  # The API module instance methods for ordering (buy and sell)
  module ApiModule
    require_relative './orders/buy'
    require_relative './orders/sell'

    def orders(order_id = nil)
      url = order_id ? "#{endpoints[:orders]}#{order_id}" : endpoints[:orders]
      raw_response = HTTParty.get(url, headers: headers)
      JSON.parse(raw_response.body)
    end

    def cancel_order(order_id)
      raw_response = HTTParty.post(
        "https://api.robinhood.com/orders/#{order_id}/cancel/", headers: headers
      )
      raw_response.code == 200
    end
  end
end
