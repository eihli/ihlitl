module IhliTL
  class FulfillmentAgent
    def initialize(*args)
      # Pass in credentials or any pre-reqs/setup here
    end

    def run(payload)
      # Perform some transform
      payload
      # Raise TransformError if failed
    end
  end
end
