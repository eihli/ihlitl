class Destination
  class << self
    def run(payload, validator)
      # Instead of calling divert inside validate_inbound
      # we can raise and rescue here. Both validate_inbound
      # and deliver can fail. Unify error handling
      return false unless validator.validate(payload)
      deliver(payload)
      true
    end

    private

    def divert
      # Log to DB, send an email...
      puts "Handle error"
    end

    def deliver(payload)
      # Save to DB, POST to external API...
      puts "Make POST to API"
      # Rescue/throw
    end
  end
end
