require 'minitest/autorun'
require_relative '../lib/agent'

class TestAgent < MiniTest::Test
  def test_agent_fulfill
    mock_agent = MiniTest::Mock.new
    agent = IhliTL::Agent.new
    agent.add mock_agent
    mock_agent.expect :fulfill, nil, [{}]
    agent.fulfill({})
    mock_agent.verify
  end
end
