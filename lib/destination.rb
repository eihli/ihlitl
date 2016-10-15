require 'http'

module IhliTL
  class Destination
    def initialize
      # Initialize with any credentials or args needed
    end

    # Define run so Destinations can be passed into Transforms
    def run(payload)
      deliver(payload)
    end

    private

    def deliver(payload)
      payload
    end
  end
end
