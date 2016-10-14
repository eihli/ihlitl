require 'minitest/autorun'
require 'http'
require_relative '../lib/destination'

class TestDestination < MiniTest::Test
  def setup
    @destination = Destination.new
  end

  def test_default_delivery_behavior_returns_payload
    payload = 'some_payload'
    assert_equal @destination.run(payload), payload
  end

  # Since subclasses will be defining deliver and not run,
  # we should test that deliver is actually called
  def test_run_calls_deliver
    payload = 'some_payload'
    destination_mock = MiniTest::Mock.new
    destination_mock.expect :call, nil, [payload]

    @destination.stub :deliver, destination_mock do
      @destination.run(payload)
    end

    destination_mock.verify
  end
end
