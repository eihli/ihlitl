require 'minitest/autorun'
require_relative '../lib/helpers'
require_relative '../lib/transform'

class TestTransform < MiniTest::Test
  def setup
    @options = {}
    @payload = { package: {} }
  end

  def test_run_sends_payload_to_destination
    mock = MiniTest::Mock.new
    mock.expect :call, nil, [@payload]
    Destination.stub :run, mock do
      Transform.run @payload
    end

    mock.verify
  end

  def test_payload_gets_transformed
    transformed_payload = deep_copy(@payload)
    transformed_payload[:package][:delivery_address] = 'some_delivery_address'

    mock = MiniTest::Mock.new
    mock.expect :call, nil, [transformed_payload]

    Destination.stub :run, mock do
      Transform.run @payload
    end

    mock.verify
  end
end
