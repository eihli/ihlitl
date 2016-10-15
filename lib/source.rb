require 'http'

module IhliTL
  class Source < Transform
    def run(payload = {})
      deliver(transform(payload, options))
    end
  end
end
