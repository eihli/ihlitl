require_relative './exceptions'
require_relative './fulfillment_agent'

module IhliTL
  class Contract
    attr_reader :parent

    def initialize(fulfillment_agent = nil, clauses = [], sub_contracts = [])
      @fulfillment_agent = fulfillment_agent
      @clauses = clauses
      @sub_contracts = sub_contracts.map do |sub_contract|
        sub_contract.new 
      end
      @errors = []
    end

    def resolve(payload)
      subject = payload[:subject]

      @sub_contracts.each do |sub_contract|
        sub_contract.resolve(payload)
      end

      @errors = verify(payload[:subject])
      if @errors.length == 0
        return payload
      end

      fulfill(payload[:subject])
      @errors = verify(payload[:subject])
      if @errors.length == 0
        return payload
      else
        payload[:errors].concat @errors
        return payload
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
