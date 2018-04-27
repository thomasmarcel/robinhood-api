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
      # raw_response.code == 200
      JSON.parse(raw_response.body)
    end

    def order(side, symbol, price, quantity, type)
      instrument = instruments(symbol)['results'][0]
      account = accounts['results'][0]

      body = {
        'account' => 'https://api.robinhood.com/accounts/' \
        "#{account['account_number']}/",
        'instrument' => 'https://api.robinhood.com/instruments/' \
        "#{instrument['id']}/",
        'quantity' => quantity,
        'symbol' => symbol,
        'type' => type
      }

      if side == 'stop_loss_sell'
        side = 'sell'
        body = body.merge(
          'side' => side,
          'stop_price' => price,
          'time_in_force' => 'gtc',
          'trigger' => 'stop'
        )
      else
        body = body.merge(
          'side' => side,
          'price' => price,
          'time_in_force' => 'gfd',
          'trigger' => 'immediate'
        )
      end

      raw_response = HTTParty.post(
        endpoints[:orders],
        body: body,
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
      order('stop_loss_sell', symbol, price, quantity, 'market')
    end
  end
end
