require_relative '../lib/exceptions'

module IhliTL
  class Contract
    attr_reader :parent

    def initialize(fulfillment_agent = nil, clauses = [], sub_contracts = [])
      @fulfillment_agent = fulfillment_agent
      @clauses = clauses
      @sub_contracts = sub_contracts
      @errors = []
    end

    def resolve(subject, parent = nil)
      @parent = parent
      #ancestor = parent
      #while ancestor
      #  if ancestor.class == self.class
      #    @errors << IhliTL::ContractError.new "Contract dependency loop."
      #    return @errors
      #  end
      #  ancestor = ancestor.parent
      #end

      @sub_contracts.each do |sub_contract|
        sub_contract.resolve(subject)
      end

      @errors = verify(subject)
      if @errors.length == 0
        return subject
      end

      fulfill(subject)
      @errors = verify(subject)
      if @errors.length == 0
        return subject
      else
        return @errors
      end
    end

    def verify(subject)
      @errors = []
      verify_clauses(subject)
    end

    def fulfill(subject)
      if @fulfillment_agent
        @fulfillment_agent.run(subject)
      end
    end

    def verify_clauses(subject)
      @clauses.each do |clause|
        begin
          errors = clause.verify(subject)
          if errors.length > 0
            @errors.concat errors
          end
        rescue => e
          @errors << e
        end
      end
      @errors
    end
  end
end
