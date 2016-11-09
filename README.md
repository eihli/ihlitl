# IhliTL

Contracts for transforming and verifying some payload.

Given some initial 'payload', some 'assertions' and some ways to 'fulfill' those assertions, make a best effort attempt to fulfill and verify all assertions.

## Example

Imagine you want to get information about a book from a number of different sources and send that information to an API to be persisted in a single location.

You can write a 'PersistBookData' contract which has an assertion that you received a 201 response from the API.

You then write a 'PostBookApiFulfillmentAgent' which accepts a payload (Hash) and tries to access properties of that hash to get the data it needs to make the request.

If the request fails, pass the payload to each sub-contract and repeat the same process.

Once all sub-contracts have attempted their resolutions, try to verify/fulfill the contract once more.

The results will be aggregated and returned.

*Example sub-contracts:*

- Do have have the books title? Let's get the author's name.
  - Did we get the author name yet? Look up biographical info on Wikipedia.
  - Get the ISBN number from Amazon's API
    - Does the payload contain the ISBN number? Get availability from nearby libraries.
- Do we have enough info to POST to the API? Go for it.

See [an example definition](examples/library/add_book_contract_definition.rb).

## Classes

### Contract

#### \#initialize(contract\_definition, parent = nil)

- Parses a contract definition
- Initializes sub-contracts
- Initializes fulfillment agents

#### \#resolve(subject)

- Verifies subject
- Attempts to fulfill contract by passing subject to FulfillmentAgent#fulfill
  - Rescues FulfillmentErrors
- Passes subject to sub-contracts for fulfillment

### Verifier

#### \#verify(assertion, subject)

- Returns true if the assertion is true, or an error message if it fails

### FulfillmentAgent

#### \#fulfill(subject)

- Transforms and returns subject
- Rescues from StandardError and places errors in an error attribute
