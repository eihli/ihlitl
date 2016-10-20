require_relative '../../lib/contract'
require_relative '../../lib/verifier'

definition = {
  name: 'Add Book To Library',
  clauses: [
    name: 'Added To Library Clause',
    verifier: IhliTL::Verifier,
    assertions: [{
      name: 'Response Code Assertion',
      msg_chain: ["[]"],
      args: ["library_response_code"],
      comaprator: "==",
      value: "201"
    }]
  ],
  fulfillment_agents: [],
  contracts: []
}

contract = IhliTL::Contract.new definition
puts contract.resolve({})
