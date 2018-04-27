module Robinhood
  # The API module instance methods for ordering (buy and sell)
  module ApiModule
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

    def order(side, symbol, price, quantity, type)
      instrument = instruments(symbol)['results'][0]
      account = accounts['results'][0]
      raw_response = HTTParty.post(
        endpoints[:orders],
        body: {
          'account' => 'https://api.robinhood.com/accounts/' \
          "#{account['account_number']}/",
          'instrument' => 'https://api.robinhood.com/instruments/' \
          "#{instrument['id']}/",
          'price' => price,
          'quantity' => quantity,
          'side' => side,
          'symbol' => symbol,
          'time_in_force' => 'gfd',
          'trigger' => 'immediate',
          'type' => type
        },
        headers: headers
      )

      JSON.parse(raw_response.body)
    end

    def buy(symbol, price, quantity)
      order('buy', symbol, price, quantity, 'market')
    end

    def limit_buy(symbol, price, quantity)
      order('buy', symbol, price, quantity, 'limit')
    end

    def sell(symbol, price, quantity)
      order('sell', symbol, price, quantity, 'market')
    end

    def limit_sell(symbol, price, quantity)
      order('sell', symbol, price, quantity, 'limit')
    end

    def stop_loss_sell(symbol, price, quantity)
      raw_response = HTTParty.post(
        endpoints[:orders],
        body: {
          'account' => "https://api.robinhood.com/accounts/#{account_number}/",
          'instrument' => 'https://api.robinhood.com/instruments/' \
          "#{instrument_id}/",
          'stop_price' => price,
          'quantity' => quantity,
          'side' => 'sell',
          'symbol' => symbol,
          'time_in_force' => 'gtc',
          'trigger' => 'stop',
          'type' => 'market'
        }.to_json,
        headers: headers
      )

      JSON.parse(raw_response.body)
    end
  end
end
