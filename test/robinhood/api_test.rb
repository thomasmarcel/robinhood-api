require 'test_helper'

class RobinhoodApiTest < Minitest::Test
  describe 'Failed Login' do
    it 'Must fail login' do
      robinhood = Robinhood::Api.new

      robinhood.login('aaa', 'bbb')
    end
  end
end
