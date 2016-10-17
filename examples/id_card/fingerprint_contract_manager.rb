require_relative '../../lib/contract_manager'
require_relative './fingerprint_fulfillment_agent'

contract_definitions = [
  {
    name: 'Fingerprint Contract',
    fulfillment_agent: {
      class: FingerprintFulfillmentAgent,
      args: ['4aaeba74af287db4']
    },
    clauses: [
      {
        name: 'Fingerprint Clause',
        assertions: [
          {
            property: 'fingerprint',
            accessor: '[]',
            attribute: 'length',
            comparator: '>',
            value: 5
          },
          {
            property: 'fingerprint',
            accessor: '[]',
            attribute: 'length',
            comparator: '<',
            value: 20
          }
        ]
      }
    ],
    sub_contracts: []
  }
]

fingerprint_contract_manager = IhliTL::ContractManager.new contract_definitions

puts fingerprint_contract_manager.resolve({fingerprint: '1'})
