require 'minitest/autorun'
require_relative '../lib/deliver_retriable'

class TestRetriable < MiniTest::Test
  class TransformClass
    prepend IhliTL::DeliverRetriable

    def deliver
      'original'
    end
  end

  def test_calls_original_deliver_method
    mock = MiniTest::Mock.new
    transform = TransformClass.new
    assert_equal transform.deliver, 'original'
  end

  def test_
end

