require_relative '../../lib/contract'
require_relative '../../lib/verifier'

definition = {
  name: 'Add Book To Library',
  class: IhliTL::Contract,
  clauses: [
    name: 'Added To Library Clause',
    verifier: IhliTL::Verifier,
    assertions: [{
      name: 'Response Code Assertion',
      msg_chain: [:[]],
      args: [[:library_response_code]],
      comparator: '==',
      value: '201'
    }]
  ],
  fulfillment_agents: [],
  contracts: [
    {
      name: 'Book Author',
      class: IhliTL::Contract,
      clauses: [
        name: 'Book Author Clause',
        verifier: IhliTL::Verifier,
        assertions: [{
          name: 'Book Author Name Exists',
          msg_chain: [:[], :length],
          args: [[:author_name]],
          comparator: '>',
          value: 5
        }]
      ],
      fulfillment_agents: [],
      contracts: []
    }
  ]
}

contract = IhliTL::Contract.new definition
puts contract.resolve({library_response_code: '202', author_name: 'hi'})
