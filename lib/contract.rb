module IhliTL
  class Contract
    attr_reader :parent

    def initialize(contract_definition, parent = nil)
      @name = contract_definition[:name]
      @clauses = contract_definition[:clauses]
      @fulfillment_agents = contract_definition[:fulfillment_agents]
      @contracts = init_contracts(contract_definition[:contracts])
      @payload = {
        contract_name: @name,
        contracts: [],
        verified_clauses: [],
        subject: {}
      }
    end

    def init_contracts(contract_definitions)
      contract_definitions.map do |contract_definition|
        contract_definition[:class].new contract_definition, parent = self
      end
    end

    def resolve(subject)
      @payload[:subject] = subject
      verified_clauses = verify(subject)
      @payload[:verified_clauses] = verified_clauses
      if get_errors(verified_clauses).flatten.length > 0
        fulfill(subject)
      end
      @contracts.each do |contract|
        @payload[:contracts] << contract.resolve(subject.clone)
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
  end
end
