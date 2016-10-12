require 'http'

class Destination
  class << self
    def run(payload)
      # Instead of calling divert inside validate_inbound
      # we can raise and rescue here. Both validate_inbound
      # and deliver can fail. Unify error handling
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
      # Rescue/throw
    end
  end
end
