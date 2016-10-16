# IhliTL

Contracts for handling API to API integrations.

~~View an [example](examples/nfl.rb) to see how it works.~~ *outdated*

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
