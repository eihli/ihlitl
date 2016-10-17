require_relative './contract'
require_relative './clause'

module IhliTL
  class ContractManager
    def initialize(contract_definitions)
      @contracts = recursively_initialize_contracts(contract_definitions)
    end

    def recursively_initialize_contracts(contract_definitions)
      contract_definitions.map do |contract_definition|
        fulfillment_agent = contract_definition[:fulfillment_agent][:class].new # args?
        clauses = contract_definition[:clauses].map do |clause|
          name = clause[:name]
          assertions = clause[:assertions]
          IhliTL::Clause.new name, assertions
        end

        sub_contracts = contract_definition[:sub_contracts]

        if sub_contracts.length == 0
          return [IhliTL::Contract.new(fulfillment_agent, clauses)]
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
