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
      @payload = {
        contract_name: @name
      }
    end

    def verify(subject)
      verified_clauses = @clauses.map do |clause|
        {
          clause: clause[:name],
          assertions:
            clause[:assertions].map do |assertion|
              {
                assertion: assertion[:name],
                result: clause[:verifier].verify(assertion)
              }
            end
        }
      end

      @payload[:verified_clauses] = verified_clauses
      verified_clauses
    end

    def init_clauses(clause_definitions)
      clause_definitions
    end
  end
end
