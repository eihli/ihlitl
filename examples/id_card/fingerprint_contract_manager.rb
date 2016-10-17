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
puts fingerprint_contract_manager.resolve({})

# {:subject=>{:fingerprint=>"61.4", :response_status=>"200"}, :errors=>[]}

contract_definitions[0][:clauses][0][:assertions][0][:value] = 5
fingerprint_contract_manager = IhliTL::ContractManager.new contract_definitions
puts fingerprint_contract_manager.resolve({})

# {:subject=>{:fingerprint=>"61.4", :response_status=>"200"}, :errors=>[#<IhliTL::ClauseError: Error: >, {:fingerprint=>"61.4", :response_status=>"200"} length, 5 but got 4>]}

contract_definitions[0][:clauses][0][:assertions][0][:value] = 3
contract_definitions[0][:sub_contracts][0][:fulfillment_agent][:args][0] = 'invalid_api_key'
fingerprint_contract_manager = IhliTL::ContractManager.new contract_definitions
puts fingerprint_contract_manager.resolve({})

#{:subject=>{}, :errors=>[#<IhliTL::FulfillmentError: Error in #<FingerprintGetFulfillmentAgent:0x007fc5f486df78> with subject {}>, #<IhliTL::ClauseError: Error: ==, {} , 200 but got >, #<IhliTL::ClauseError: undefined method `length' for nil:NilClass>, nil, #<IhliTL::ClauseError: undefined method `length' for nil:NilClass>, nil, #<IhliTL::ClauseError: undefined method `length' for nil:NilClass>, nil]}

