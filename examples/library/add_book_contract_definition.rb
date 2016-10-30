require 'json'
require_relative '../../lib/contract'
require_relative '../../lib/verifier'
require_relative './post_to_library'
require_relative './get_author_name'

library_api_key = '12345'
author_email_address = 'baz@example.com'

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
  contracts: [
    {
      name: 'Book Author',
      class: IhliTL::Contract,
      fulfillment_agents: [{
        class: GetAuthorName,
        args: [author_email_address]
      }],
      clauses: [
        name: 'book author name length',
        verifier: IhliTL::Verifier,
        assertions: [{
          name: 'greater than 2',
          msg_chain: [:[], :length],
          args: [[:name]],
          comparator: '>',
          value: 2
        },
        {
          name: 'less than 10',
          msg_chain: [:[], :length],
          args: [[:name]],
          comparator: '<',
          value: 10
        }]
      ],
      contracts: []
    }
  ]
}

contract = IhliTL::Contract.new definition
puts JSON.pretty_generate contract.resolve({})
