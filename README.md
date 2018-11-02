# IhliTL

Contracts for transforming and verifying some payload.

Given some initial 'payload', some 'assertions' and some ways to 'fulfill' those assertions, make a best effort attempt to fulfill and verify all assertions.

## Example

That sounds very abstract and mushy. To put it more concretely:

I am a company who works with several SaaS providers.

- NetSuite handles project management and scheduling.
- Intuit handles accounting and finances.
- GraphSuite handles converting csv files to graphs.
- GloboWorld handles media and marketing.

When a project is marked as "complete" in NetSuite, I want an automated
process to create a graph of the expense over time and to upload that graph
to GloboWorld so our media company has access to it.

_So the trigger is:_ "Project marked as *complete* in NetSuite".

_The reaction is:_ "Graph of expenses over time get uploaded to GloboWorld".

The steps along the way include:

- Download financial data for time period as .csv from Intuit
- Send financial data to GraphSuite and get back a .png graph
- Upload the graph to GloboWorld

There are several circumstances we need to handle.

- If we already have a .png graph of the financial data because someone created it by
hand *before* marking the project as complete, we want to just use that existing .png graph.
- If a SaaS api endpoint responds with an HTTP code indicating a temporary failure, we want to retry.
- If a SaaS api endpoint responds with an HTTP code indicating a malformed request, we want to log that so we manually address the issue.

## Idea for Implementation

1. Event triggers, program for "NetSuite project marked as complete" is run.
2. We run an "agent" to resolve the task of uploading the .png graph to GloboWorld
   1. That agent detects that we don't have a .png yet so it can't resolve without fulfilling some sub-requirements
   2. It runs the code to fulfill the requirements
	  1. Run the agent to fulfill the task of getting the .csv of the financial data.
		  1. The agent detects that we already ran the report for the .csv so it doesn't bother running the agent to fulfill the task of running of the report.
	  1. Run the agent to fulfill the task of uploading the .csv to GraphSuite
   3. etc...

So it's like traversing a tree of fulfilling requirements.

## Why?

Why not just write the logic in the code to do all of this? Why the extra step of allowing this to be defined in a config file?

The idea is that the code can be written once and then the agents can be shuffled around and connected to each other in any
number of different ways.

There may be other/better ways to go about this and if you can think of any, we'd be happy to hear your thoughts.

## Another Example

Here is another example that is similar to the code you'll find in the `examples` folder.

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

## Example Definition

```
definition = {
  name: 'Post Book To Library API',
  class: IhliTL::Contract,
  fulfillment_agents: [{
    class: PostToLibrary,
    args: [library_api_key]
  }],
  clauses: [
    name: 'added to library',
    verifier: IhliTL::Verifier,
    assertions: [{
      name: 'response code success',
      msg_chain: [:[]],
      args: [[:library_response_code]],
      comparator: '==',
      value: '201'
    }]
  ],
  contracts: []
}
```
