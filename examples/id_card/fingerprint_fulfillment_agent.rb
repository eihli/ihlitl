require 'http'
require_relative '../../lib/fulfillment_agent'

class FingerprintFulfillmentAgent < IhliTL::FulfillmentAgent
  def initialize(api_key)
    @api_key = api_key + 'h'
  end

  def run(subject)
    response = HTTP.get("http://api.wunderground.com/api/#{@api_key}/conditions/q/CA/San_Francisco.json")
    subject[:fingerprint] = JSON.parse(response)["current_observation"]["temp_f"].to_s
    subject
  end
end
