require_relative './exceptions'
require_relative './fulfillment_agent'

module IhliTL
  class Contract
    attr_reader :parent

    def initialize(contract_definition, parent = nil)
      @name = contract_definition[:name]
      @clauses = init_clauses(contract_definition[:clauses])
      @fulfillment_agents = contract_definition[:fulfillment_agents]
      @contracts = contract_definition[:contracts]
    end

    def verify(payload)
      @clauses.map do |clause|
        clause[:assertions].map do |assertion|
          #####
          # Our 'Verifier' class here has a method
          # named 'verify' which is also a method
          # used by MiniTest::Mock.
          # A problem when we try to mock this dependency...
          #####
          clause[:verifier].verify(assertion)
        end
      end
    end

    def init_clauses(clause_definitions)
      clause_definitions
    end
  end
end
