require 'http'
require_relative './transform'

class Source
  class << self

    def run(payload, options)
      deliver(transform(payload, options), options)
    end

    private

    def transform(payload, options)
      response = HTTP.post(options[:source_address], options[:credentials])
      payload[:package] = response
    end

    def deliver(payload, options)
      Transform.run(payload, options)
    end
  end
end
