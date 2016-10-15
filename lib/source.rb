require 'http'
require_relative './transform'

module IhliTL
  class Source < Transform
    def run(payload = {})
      deliver(transform(payload, options))
    end
  end
end
