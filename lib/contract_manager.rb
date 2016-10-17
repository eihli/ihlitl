require_relative './contract'
require_relative './clause'

module IhliTL
  class ContractManager
    def initialize(contract_definitions)
      @contracts = recursively_initialize_contracts(contract_definitions)
    end

    def recursively_initialize_contracts(contract_definitions)
      contract_definitions.map do |contract_definition|
        if contract_definition[:fulfillment_agent]
          fulfillment_agent = contract_definition[:fulfillment_agent][:class].new(
            *contract_definition[:fulfillment_agent][:args]
          )
        end
        clauses = contract_definition[:clauses].map do |clause|
          name = clause[:name]
          assertions = clause[:assertions]
          IhliTL::Clause.new name, assertions
        end

        sub_contract_definitions = contract_definition[:sub_contracts]
        if sub_contract_definitions.length == 0
          IhliTL::Contract.new fulfillment_agent, clauses
        else
          sub_contracts = recursively_initialize_contracts(sub_contract_definitions)
          IhliTL::Contract.new fulfillment_agent, clauses, sub_contracts
        end
      end
    end

    def resolve(subject)
      payload = {
        subject: subject,
        errors: []
      }
      errors = []
      @contracts.each do |contract|
        contract.resolve(payload)
      end
      payload
    end
  end
end
