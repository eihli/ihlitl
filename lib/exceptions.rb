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
    def initialize(fulfillment_agent, subject, e)
      @fulfillment_agent = fulfillment_agent
      @subject = subject
      @e = e
      super message
    end

    def message
      "Error in #{@fulfillment_agent} with subject #{@subject}. Original error: #{@e}"
    end
  end
end
