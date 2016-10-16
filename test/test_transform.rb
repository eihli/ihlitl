require 'minitest/autorun'
require_relative '../lib/transform'

class TestTransform < MiniTest::Test
  def setup
    @transform = IhliTL::Transform.new
  end

  def test_transform_returns_payload_by_default
    some_payload = {key: 'value'}
    assert_equal some_payload, @transform.transform(some_payload)
  end
end
