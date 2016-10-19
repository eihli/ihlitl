require 'minitest/autorun'
require_relative '../lib/contract'

class TestContract < MiniTest::Test
  def setup
    @mock_verifier = MiniTest::Mock.new

    # Our Verify object has the same 'verify' method name that MiniTest::Mock uses.
    # This is a hack-around since ours expects a param

    def @mock_verifier.assert
      -> { @mock_verifier.method(:verify) }
    end

    @mock_verifier.instance_eval 'undef :verify'

    @assertion = {
      msg_chain: ['[]'],
      args: ['test_arg'],
      comparator: '==',
      value: 'test_value'
    }

    @contract_definition = {
      name: 'Test Contract',
      clauses: [
        name: 'Test Clause',
        verifier: @mock_verifier,
        assertions: [@assertion],
      ],
      fulfillment_agents: [],
      contracts: []
    }
  end

  def test_verify_verifies_each_clause_with_assertion
    @mock_verifier.expect :verify, nil, [@assertion]
    @contract = IhliTL::Contract.new @contract_definition
    @contract.verify({})
    @mock_verifier.assert
  end
end
