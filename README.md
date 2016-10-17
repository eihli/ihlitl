# IhliTL

Contracts for handling API to API integrations.

## Example

### If the Contract resolves with a success

This will happen if a Contract is able to fulfill itself.

```
fingerprint_contract_manager = IhliTL::ContractManager.new contract_definitions
puts fingerprint_contract_manager.resolve({})

# {:subject=>{:fingerprint=>"61.4", :response_status=>"200"}, :errors=>[]}
```

### If the Contract resolves with a failure in a Clause assertion

This will happen if a Contract is unable to fulfill itself.

```
contract_definitions[0][:clauses][0][:assertions][0][:value] = 5
fingerprint_contract_manager = IhliTL::ContractManager.new contract_definitions
puts fingerprint_contract_manager.resolve({})

# {:subject=>{:fingerprint=>"61.4", :response_status=>"200"}, :errors=>[#<IhliTL::ClauseError: Error: >, {:fingerprint=>"61.4", :response_status=>"200"} length, 5 but got 4>]}
```

### If the Contract resolves with an exception while trying to fulfill itself

This could happen if for example an external API was down, or your credentials are wrong.

```
contract_definitions[0][:clauses][0][:assertions][0][:value] = 3
contract_definitions[0][:sub_contracts][0][:fulfillment_agent][:args][0] = 'invalid_api_key'
fingerprint_contract_manager = IhliTL::ContractManager.new contract_definitions
puts fingerprint_contract_manager.resolve({})

#{:subject=>{}, :errors=>[#<IhliTL::FulfillmentError: Error in #<FingerprintGetFulfillmentAgent:0x007fc5f486df78> with subject {}>, #<IhliTL::ClauseError: Error: ==, {} , 200 but got >, #<IhliTL::ClauseError: undefined method `length' for nil:NilClass>, nil, #<IhliTL::ClauseError: undefined method `length' for nil:NilClass>, nil, #<IhliTL::ClauseError: undefined method `length' for nil:NilClass>, nil]}
```

### Contract Definition

```
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
```

## Current State (Oct 16th)

### Contract

- Have 0 or many `clauses` <Clause>
- Have 0 or many `sub_contracts` <Contract>
- `#resolve` ->
  - Resolves `sub_contracts`
  - Resolves itself
    - Verifies `clauses`
      - If verification fails
        - Runs `#fulfill` on its `fulfillment_agent` <FulfillmentAgent>
      - (TODO: Implement retriable logic)
  - (TODO: Async resolves)

### Clause

- Has 1 `subject`
- Has 0 to many `options` <Hash>
- `#verify` -> (TODO: Rename this to errors)
  - Evaluates each `option` ->
    - `subject.send(option[:accessor].to_sym, option[:property].to_sym).send(option[:comparator].to_sym, option[:value])`
  - Returns list of errors/exceptions

### FulfillmentAgent
- `#run(subject)` ->
  - Transforms and returns `subject`
