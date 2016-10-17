require 'http'
require_relative '../../lib/fulfillment_agent'

class FingerprintFulfillmentAgent < IhliTL::FulfillmentAgent
  def run(subject)
    subject
  end
end
