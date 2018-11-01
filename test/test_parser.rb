require 'minitest/autorun'
require_relative '../lib/parser'

class TestParser < MiniTest::Test
  class MockAgent
    attr_reader :called
    def initialize
      @called = false
    end
    def add(child)
      @called = true
    end
  end

  def test_parser
    definitions = {
      class: MiniTest::Mock.new,
      args: [1],
      definitions: [
        {
          class: MiniTest::Mock.new,
          args: [2],
          definitions: []
        }
      ]
    }
    parent_agent = MockAgent.new
    definitions[:class].expect :new, parent_agent, [1]
    child_agent = MockAgent.new
    definitions[:definitions][0][:class].expect :new, child_agent, [2]
    agent = IhliTL::Parser.parse(definitions)
    definitions[:class].verify
    definitions[:definitions][0][:class].verify
    assert_equal true, parent_agent.called
    assert_equal false, child_agent.called
  end
end
