require_relative '../../lib/fulfillment_agent'

class FingerprintGetFulfillmentAgent < IhliTL::FulfillmentAgent
  def initialize(api_key)
    @api_key = api_key
  end

  def run(subject)
    response = HTTP.get("http://api.wunderground.com/api/#{@api_key}/conditions/q/CA/San_Francisco.json")
    subject[:fingerprint] = JSON.parse(response)["current_observation"]["temp_f"].to_s
    subject[:response_status] = '200'
    subject
  end
end
