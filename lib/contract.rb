require_relative '../lib/exceptions'

module IhliTL
  class Contract
    def initialize(subject, fulfillment_agent, clauses = [], sub_contracts = [])
      @subject = subject
      @fulfillment_agent = fulfillment_agent
      @clauses = clauses
      @sub_contracts = sub_contracts
      @errors = []
      @exceptions = []
    end

    def resolve(subject)
      @sub_contracts.each do |sub_contract|
        sub_contract.resolve(subject)
      end

      if verify(subject)
        return subject
      end

      fulfill(subject)
      if verify(subject)
        return subject
      else
        if @exceptions.length > 0
          raise StandardError.new @exceptions
        elsif @errors.length > 0
          raise ContractError.new "Verify failed with #{@errors}"
        end
      end
    end

    def verify(subject)
      @errors = []
      @exceptions = []
      verify_clauses(subject)
      @errors.length == 0 && @exceptions.length == 0
    end

    def fulfill(subject)
      @fulfillment_agent.run(subject)
    end

    def verify_clauses(subject)
      @clauses.each do |clause|
        begin
          if clause[:predicate].call(subject) == false
            @errors << "Validation failed on #{clause[:description]} with #{subject}"
          end
        rescue => e
          @exceptions << e
        end
      end
    end
  end
end
