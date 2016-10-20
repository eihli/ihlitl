module IhliTL
  class Contract
    attr_reader :parent

    def initialize(contract_definition, parent = nil)
      @name = contract_definition[:name]
      @clauses = contract_definition[:clauses]
      @fulfillment_agents = init_fulfillment_agents(
        contract_definition[:fulfillment_agents]
      )
      @contracts = init_contracts(contract_definition[:contracts])
      @payload = {
        contract_name: @name,
        contracts: [],
        clauses: [],
        fulfillment_errors: [],
      }
    end

    def init_contracts(contract_definitions)
      contract_definitions.map do |contract_definition|
        contract_definition[:class].new contract_definition, parent = self
      end
    end

    def init_fulfillment_agents(agent_definitions)
      agent_definitions.map do |agent_definition|
        agent_definition[:class].new *agent_definition[:args]
      end
    end

    def resolve(subject)
      if get_errors(verify(subject)).flatten.length > 0
        fulfill(subject)
      end
      if get_errors(verify(subject)).flatten.length > 0
        @contracts.each do |contract|
          @payload[:contracts] << contract.resolve(subject)
        end
      end
      @payload[:clauses] = verify(subject)
      fulfill(subject)
      @payload[:fulfillment_errors] = get_fulfillment_agent_errors(@fulfillment_agents)
      [@payload, subject]
    end

    def get_errors(clauses)
      clauses.map do |verified_clause|
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
      clauses = @clauses.map do |clause|
        {
          clause: clause[:name],
          subject: subject,
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
      clauses
    end

    def fulfill(subject)
      @fulfillment_agents.map do |fulfillment_agent|
        fulfillment_agent.fulfill(subject)
      end
    end

    def get_fulfillment_agent_errors(fulfillment_agents)
      fulfillment_agents.map do |fulfillment_agent|
        fulfillment_agent.error
      end
    end
  end
end
