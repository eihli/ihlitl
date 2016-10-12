require 'http'
require 'transform'

class Source
  class << self

    def run(payload, options)
      deliver(transform(payload, options))
    end

    private

    def transform(payload, options)
      response = HTTP.post(options[:source_address], options[:credentials])
      payload[:package] = response
    end

    def deliver(payload)
      Transform.run(payload, options)
    end
  end
end
