require 'http'
require_relative './transform'

class Source < Transform
  def run(payload = {})
    deliver(transform(payload, options))
  end
end
