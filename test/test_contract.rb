require 'minitest/autorun'
require_relative '../lib/contract'

class TestContract < MiniTest::Test
  def get_contract_definition(verifier, assertions)
    {
      name: 'Test Contract',
      clauses: [
        name: 'Test Clause',
        verifier: verifier,
        assertions: [assertions],
      ],
      fulfillment_agents: [],
      contracts: []
    }
  end

  def setup
    @mock_verifier = MiniTest::Mock.new

    # Our Verify object has the same 'verify' method name that MiniTest::Mock uses.
    # This is a hack-around since ours expects a param

    def @mock_verifier.assert
      -> { @mock_verifier.method(:verify) }
    end

    @mock_verifier.instance_eval 'undef :verify'

    @assertion = {
      name: 'Expect [:test_arg] == test_value',
      msg_chain: ['[]'],
      args: ['test_arg'],
      comparator: '==',
      value: 'test_value'
    }
  end

  def test_verify_verifies_each_clause_with_assertion
    contract_definition = get_contract_definition(@mock_verifier, @assertion)
    @mock_verifier.expect :verify, [], [@assertion]
    contract = IhliTL::Contract.new contract_definition
    @mock_verifier.assert
  end

  def test_verify_returns_verified_clauses
    contract = nil
    @mock_verifier.stub :verify, [] do
      contract = IhliTL::Contract.new @contract_definition
    end
    assert_equal contract.verify({}), ['hi']
  end
end
