require 'minitest/autorun'
require_relative '../lib/transform'

class TestTransform < MiniTest::Test
  def setup
  end

  def test_run
    assert Transform.run == true
  end
end
