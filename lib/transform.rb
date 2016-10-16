module IhliTL
  class Transform
    def initialize(*args)
      # Pass in credentials or any pre-reqs/setup here
    end

    def transform(payload)
      # Perform some transform
      payload
      # Raise TransformError if failed
    end
  end
end

