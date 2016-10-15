require 'minitest/autorun'
require_relative '../lib/source'

class TestSource < MiniTest::Test
  def test_source_inherits_from_transform
    assert IhliTL::Source < IhliTL::Transform, true
  end
end
