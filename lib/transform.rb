require_relative './destination'

class Transform
  class << self

    def run(payload, options)
      deliver(transform(payload), options)
    end

    private

    def deliver(payload, options)
      Destination.run payload, options
    end

    def transform(payload)
      payload[:package][:delivery_address] = 'some_delivery_address'
      payload
    end
  end
end

