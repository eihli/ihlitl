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

    def resolve(subject)
      verified_clauses = verify(subject)
      @payload[:verified_clauses] = verified_clauses
      if get_errors(verified_clauses).flatten.length > 0
        fulfill(subject)
      end
      @payload
    end

    def get_errors(verified_clauses)
      verified_clauses.map do |verified_clause|
        verified_clause[:assertions].map do |assertion|
          if assertion[:result] == true
            nil
          else
            assertion[:result]
          end
        end.compact
      end
    end

    def verify(subject)
      verified_clauses = @clauses.map do |clause|
        {
          clause: clause[:name],
          assertions:
            clause[:assertions].map do |assertion|
              {
                assertion: assertion[:name],
                result:
                  begin
                    clause[:verifier].verify(assertion, subject)
                  rescue => e
                    e
                  end
              }
            end
        }
      end
      verified_clauses
    end

    def fulfill(subject)
      @fulfillment_agents.map do |fulfillment_agent|
        fulfillment_agent.fulfill(subject)
      end
    end

    def init_clauses(clause_definitions)
      clause_definitions
    end
  end
end
