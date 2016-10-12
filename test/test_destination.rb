require 'minitest/autorun'
require 'http'
require_relative '../lib/destination'

class TestDestination < MiniTest::Test
  def setup
    @payload = {
      package: {}
    }
  end

  def test_run_with_valid_payload
    mock = MiniTest::Mock.new
    mock.expect :call, nil, ['success_url']

    HTTP.stub :post, mock do
      @payload[:package][:delivery_address] = "success_url"
      Destination.run @payload
    end

    mock.verify
  end

  def test_run_with_invalid_payload
    mock = MiniTest::Mock.new
    mock.expect :call, nil, ['failure_url']

    HTTP.stub :post, mock do
      Destination.stub :validate, false do
        @payload[:package][:diversion_address] = "failure_url"
        Destination.run @payload
      end
    end

    mock.verify
  end
end
