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
      # See if we have any errors. The contract may already be fulfilled
      if get_errors(verify(subject)).flatten.length > 0
        fulfill(subject)
      end

      # See if we have any errors after trying to fulfill ourself
      # If so, let's try to fulfill our sub-contracts
      if get_errors(verify(subject)).flatten.length > 0
        @contracts.each do |contract|
          contract.resolve(subject)
        end
      end

      if get_errors(verify(subject)).flatten.length > 0
        fulfill(subject)
      end

      # Store off relevant data and return
      @payload[:verification_results] = verification_results(subject)
      @payload[:fulfillment_errors] = get_fulfillment_agent_errors(@fulfillment_agents)

      # This return value gets lost on inner contracts but we have it
      # for the future if we want to do something with it
      [@payload, subject]
    end

    def verification_results(subject)
      result = {}
      result[:name] = @name
      result[:errors] = get_errors(verify(subject))
      result[:contracts] = @contracts.map do |contract|
        contract.verification_results(subject)
      end
      result
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
        puts "Verifying #{clause[:name]}"
        {
          clause: clause[:name],
          subject: subject.clone,
          assertions:
            clause[:assertions].map do |assertion|
              {
                assertion: assertion[:name],
                result:
                  begin
                    result = clause[:verifier].verify(assertion, subject)
                    result
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
        puts "Attempting to fulfill #{@name} with #{fulfillment_agent.class}"
        fulfillment_agent.fulfill(subject)
      end
    end

    def get_fulfillment_agent_errors(fulfillment_agents)
      fulfillment_agents.map do |fulfillment_agent|
        fulfillment_agent.error
      end.compact
    end
  end
end
