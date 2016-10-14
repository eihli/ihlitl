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
end
