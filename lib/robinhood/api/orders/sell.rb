module Robinhood
  # The API module instance methods for ordering (buy and sell)
  module ApiModule
    def sell(account_number, symbol, instrument_id, price, quantity)
      raw_response = HTTParty.post(
        endpoints[:orders],
        body: {
          'account' => "https://api.robinhood.com/accounts/#{account_number}/",
          'instrument' => 'https://api.robinhood.com/instruments/' \
          "#{instrument_id}/",
          'price' => price,
          'quantity' => quantity,
          'side' => 'sell',
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
          'instrument' => 'https://api.robinhood.com/instruments/' \
          "#{instrument_id}/",
          'price' => price,
          'quantity' => quantity,
          'side' => 'sell',
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
