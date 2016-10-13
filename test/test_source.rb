require 'minitest/autorun'
require 'http'
require_relative '../lib/helpers'
require_relative '../lib/source'
require_relative '../lib/transform'

class TestSource < MiniTest::Test
  def setup
    @options = {
      source_address: 'some_source_address',
      credentials: { username: 'some_username' }
    }
    @payload = {
      package: {}
    }
  end

  def test_run_delivers_transformed_payload
    transformed_payload = deep_copy(@payload)
    transformed_payload[:package] = { some_data: 'some_data' }

    http_mock = MiniTest::Mock.new
    http_mock.expect :call, transformed_payload, [@options[:source_address], @options[:credentials]]

    transform_mock = MiniTest::Mock.new
    transform_mock.expect :call, nil, [transformed_payload, @options]

    Transform.stub :deliver, transform_mock do
      HTTP.stub :post, http_mock do
        Source.run(@payload, @options)
      end
    end

    http_mock.verify
    transform_mock.verify
  end
end
