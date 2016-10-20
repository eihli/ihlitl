require 'minitest/autorun'
require 'ostruct'
require_relative '../lib/contract'

class TestContract < MiniTest::Test
  def get_contract_definition(verifier = nil, assertions = [], fulfillment_agents = [])
    {
      name: 'Test Contract',
      clauses: [
        name: 'Test Clause',
        verifier: verifier,
        assertions: assertions,
      ],
      fulfillment_agents: fulfillment_agents,
      contracts: []
    }
  end

  def setup
    @mock_verifier = MiniTest::Mock.new

    # Our Verify object has the same 'verify' method name that MiniTest::Mock uses.
    # This is a hack-around since ours expects a param


    @mock_verifier.instance_eval {
			def assert
				@expected_calls.each do |name, expected|
					actual = @actual_calls.fetch(name, nil)
					raise MockExpectationError, "expected #{__call name, expected[0]}" unless actual
					raise MockExpectationError, "expected #{__call name, expected[actual.size]}, got [#{__call name, actual}]" if
						actual.size < expected.size
				end
				true
			end
    }

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
    contract_definition = get_contract_definition(@mock_verifier, [@assertion])
    @mock_verifier.expect :verify, [], [@assertion, {}]
    contract = IhliTL::Contract.new contract_definition
		contract.verify({})
    @mock_verifier.assert
  end

  def test_verify_returns_verified_clauses
    stub_verifier = OpenStruct.new(verify: nil)
    contract = IhliTL::Contract.new(
      get_contract_definition(stub_verifier, [@assertion])
    )

    stub_verifier.stub :verify, true do
      assert_equal contract.verify({}), [{:clause=>"Test Clause", :assertions=>[{:assertion=>"Expect [:test_arg] == test_value", :result=>true}]}]
    end
  end

  def test_fulfill_runs_fulfillment_agents
    mock_fulfillment_agent = MiniTest::Mock.new
    mock_fulfillment_agent.expect :fulfill, nil, [{}]
    contract = IhliTL::Contract.new(
      get_contract_definition(nil, [], [mock_fulfillment_agent])
    )
    contract.fulfill({})
    mock_fulfillment_agent.verify
  end

  def test_resolve_tries_to_fulfill_if_clauses_raises
    verifier_exception = -> (assertion, subject) { raise StandardError }
    stub_verifier = OpenStruct.new(verify: nil)

    mock_fulfillment_agent = MiniTest::Mock.new
    mock_fulfillment_agent.expect :fulfill, nil, [{}]

    contract = IhliTL::Contract.new get_contract_definition(
      stub_verifier,
      [@assertion],
      [mock_fulfillment_agent]
    )

    stub_verifier.stub :verify, verifier_exception do
      contract.resolve({})
    end

    mock_fulfillment_agent.verify
  end

  def test_resolve_returns_modified_payload
    stub_verifier = OpenStruct.new(verify: nil)

    contract = IhliTL::Contract.new get_contract_definition(
      stub_verifier,
      [@assertion],
      nil
    )

    expected_resolved_payload = {
      contract_name: "Test Contract",
      verified_clauses: [
        {
          clause: "Test Clause",
          assertions: [
            {
              assertion: "Expect [:test_arg] == test_value",
              result: true
            }
          ]
        }
      ]
    }

    stub_verifier.stub :verify, true do
      assert_equal contract.resolve({}), expected_resolved_payload
    end
  end
end
