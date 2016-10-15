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
    mock.expect :call, nil
    transform = TransformClass.new
    transform.stub :deliver, mock do
      transform.deliver
    end
    mock.verify
  end
end

