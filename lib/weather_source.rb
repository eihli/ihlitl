require 'http'
require_relative './source'

class WeatherSource < Source
  class << self
    def run(payload, options)
      deliver(transform(payload, options))
    end

    private

    def transform(payload, options)
      response = HTTP.get('http://api.wunderground.com/api/4aaeba74af287db4/conditions/q/CA/San_Francisco.json')
      response = JSON.parse(response)
      payload[:package] ||= {}
      payload[:package][:temp] = response["current_observation"]["temp_f"]
      payload
    end

    def deliver(payload, options)

    end
  end
end
