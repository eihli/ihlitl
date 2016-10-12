require 'http'

class Destination
  class << self
    def run(payload)
      # Validate, deliver, or divert could blow up or fail.
      # Perhaps throwing from validate/deliver and catching divert?
      if validate(payload)
        deliver(payload)
      else
        divert(payload)
      end
    end

    def validate(payload)
      # Call to shared validator or define custom validation here
      payload[:errors] ||= []
      if payload[:package] == nil
        payload[:errors] << "Package not in payload."
        false
      else
        true
      end
    end

    private

    def divert(payload)
      HTTP.post(payload[:package][:diversion_address])
      # Log to DB, send an email...
      puts payload[:errors]
    end

    def deliver(payload)
      HTTP.post(payload[:package][:delivery_address])
      # Save to DB, POST to external API...
      puts "Make POST to API"
    end
  end
end
