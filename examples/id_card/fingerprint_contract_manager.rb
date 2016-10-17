require_relative '../../lib/contract_manager'
require_relative './fingerprint_fulfillment_agent'
require_relative './fingerprint_get_fulfillment_agent'

contract_definitions = [
  {
    name: 'Fingerprint Contract',
    clauses: [
      {
        name: 'Fingerprint Clause',
        assertions: [
          {
            property: 'fingerprint',
            accessor: '[]',
            attribute: 'length',
            comparator: '>',
            value: 3
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
    sub_contracts: [
      {
        name: 'Fingerprint Get Contract',
        fulfillment_agent: {
          class: FingerprintGetFulfillmentAgent,
          args: ['4aaeba74af287db4']
        },
        clauses: [
          {
            name: 'Fingerprint Get Clauses',
            assertions: [
              {
                property: 'response_status',
                accessor: '[]',
                comparator: '==',
                value: '200'
              },
              {
                property: 'fingerprint',
                accessor: '[]',
                attribute: 'length',
                comparator: '>',
                value: 3
              }
            ]
          }
        ],
        sub_contracts: []
      }
    ]
  }
]

fingerprint_contract_manager = IhliTL::ContractManager.new contract_definitions

puts fingerprint_contract_manager.resolve({fingerprint: '1'})
