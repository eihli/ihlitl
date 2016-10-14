require 'minitest/autorun'
require_relative '../lib/transform'

class TestTransform < MiniTest::Test
  def setup
    @destination_mock = MiniTest::Mock.new
    @transform = Transform.new @destination_mock
  end

  def test_run_sends_payload_to_destination
    payload = 'some_payload'

    @destination_mock.expect :run, nil, [payload]
    @transform.run payload
    @destination_mock.verify
  end

  class SubTransform < Transform
    def transform(payload)
      payload = payload + '_transformed'
    end
  end

  def test_payload_gets_transformed
    payload = 'some_payload'
    @transform = SubTransform.new @destination_mock

    @destination_mock.expect :run, nil, [payload + '_transformed']
    @transform.run payload
  end

  class OptionalArgSubTransform < Transform
    attr_accessor :some_arg
    def initialize(destination, some_arg)
      @some_arg = some_arg
      super
    end
  end

  def test_can_be_initialized_with_optional_args
    transform = OptionalArgSubTransform.new('some_destination', 'some_arg')
    assert_equal transform.some_arg, 'some_arg'
  end
end
