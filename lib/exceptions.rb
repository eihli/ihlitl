module IhliTL
  class TransformError < StandardError
    attr_accessor :transform, :payload

    def initialize(transform, payload)
      @transform = transform
      @payload = payload
    end
  end
end
