require_relative './exceptions'

module IhliTL
  class FulfillmentAgent
    def initialize(*args)
      @errors = []
    end

    def fulfill(subject)
      subject
    rescue => e
      raise FulfillmentError.new self, subject
    end
  end
end
