require 'destination'

class Transform
  class << self

    def run(payload)
      deliver(transform(payload))
    end

    private

    def deliver(payload)
      Destination.run payload
    end

    def transform(payload)
      payload[:package][:delivery_address] = 'some_delivery_address'
      payload
    end
  end
end

