require 'http'
require 'transform'

class Source
  class << self

    def run(payload)
      deliver(transform(payload))
    end

    private

    def transform(payload)
      response = HTTP.post(payload[:source_address], payload[:credentials])
      payload[:package] = response
    end

    def deliver(payload)
      Transform.run(payload)
    end
  end
end
