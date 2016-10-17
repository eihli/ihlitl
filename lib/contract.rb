require_relative './exceptions'
require_relative './fulfillment_agent'

module IhliTL
  class Contract
    attr_reader :parent

    def initialize(fulfillment_agent = nil, clauses = [], sub_contracts = [])
      @fulfillment_agent = fulfillment_agent
      @clauses = clauses
      @sub_contracts = sub_contracts
      @errors = []
    end

    def resolve(payload)
      @errors = []

      @sub_contracts.each do |sub_contract|
        sub_contract.resolve(payload)
      end

      @errors.concat verify(payload[:subject])
      if @errors.length == 0
        return payload
      end

      @errors = []
      fulfill(payload[:subject])

      @errors.concat verify(payload[:subject])
      if @errors.length == 0
        return payload
      else
        payload[:errors].concat @errors
        return payload
      end
    end

    def verify(subject)
      verify_clauses(subject)
    end

    def fulfill(subject)
      if @fulfillment_agent
        begin
          @fulfillment_agent.run(subject)
        rescue => e
          error = IhliTL::FulfillmentError.new @fulfillment_agent, subject
          @errors.concat [error]
        end
      end
    end

    def verify_clauses(subject)
      accum_errors = []
      @clauses.each do |clause|
        begin
          errors = clause.verify(subject)
          if errors.length > 0
            accum_errors.concat errors
          end
        rescue => e
          accum_errors.concat [e]
        end
      end
      accum_errors
    end
  end
end
