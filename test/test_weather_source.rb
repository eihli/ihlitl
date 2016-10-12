require 'minitest/autorun'
require_relative '../lib/weather_source'
require_relative '../lib/helpers'

class TestWeatherSource < MiniTest::Test
  def setup
    @options = {}
    @payload = { package: {} }
  end

  def test_run_calls_deliver_with_transformed_payload
    transformed_payload = deep_copy @payload
    transformed_payload[:package][:temp] = '66.5'

    mock = MiniTest::Mock.new
    mock.expect :call, nil, [transformed_payload]
    WeatherSource.stub :deliver, mock do
      WeatherSource.run @payload, @options
    end

    mock.verify
  end
end
