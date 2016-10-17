module IhliTL
  class TransformError < StandardError
    attr_accessor :transform, :payload

    def initialize(transform, payload)
      @transform = transform
      @payload = payload
    end
  end

  class ContractError < StandardError; end

  class ClauseError < StandardError; end

  class FulfillmentError < StandardError
    def initialize(fulfillment_agent, subject)
      @fulfillment_agent = fulfillment_agent
      @subject = subject
      super message
    end

    def message
      "Error in #{@fulfillment_agent} with subject #{@subject}"
    end
  end
end
