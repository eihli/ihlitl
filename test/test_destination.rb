require 'minitest/autorun'
require_relative '../lib/destination'

class TestDestination < MiniTest::Test
  def setup
  end

  def test_run
    assert Destination.run == true
  end
end
