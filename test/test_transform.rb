require 'minitest/autorun'
require_relative '../lib/transform'

class TestTransform < MiniTest::Test
  def setup
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
end
