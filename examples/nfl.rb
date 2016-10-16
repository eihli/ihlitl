require_relative '../lib/transform'
require_relative '../lib/contract'
require_relative '../lib/fulfillment_agent'

zip_code_clauses = [
  {
    description: 'Zip code',
    predicate: -> (payload) {
      payload[:zip_code].length == 5
    }
  }
]
class ZipCodeFulfillmentAgent < IhliTL::FulfillmentAgent
  def run(payload)
    payload[:zip_code] = '94110'
  end
end
zip_code_fulfillment_agent = ZipCodeFulfillmentAgent.new
zip_code_contract = IhliTL::Contract.new({}, zip_code_fulfillment_agent, zip_code_clauses)

temp_clauses = [
  {
    description: 'Temp type',
    predicate: -> (payload) {
      Float(payload[:temp_f]).class == Float
    }
  }
]
class TemperatureFulfillmentAgent < IhliTL::FulfillmentAgent
  def run(payload)
    payload[:temp_f] = '56.4'
  end
end
temp_fulfillment_agent = TemperatureFulfillmentAgent.new
temp_sub_contracts = [zip_code_contract]
temp_contract = IhliTL::Contract.new({}, temp_fulfillment_agent, temp_clauses, temp_sub_contracts)

weather_clauses = [
  {
    description: 'Zip code length',
    predicate: -> (payload) {
      payload[:zip_code].length == 5
    }
  },
  {
    description: 'Temp type',
    predicate: -> (payload) {
      Float(payload[:temp_f]).class == Float
    }
  },
  {
    description: 'Post response status',
    predicate: -> (payload) {
      payload[:response_status] == '201'
    }
  }
]

class WeatherFulfillmentAgent < IhliTL::FulfillmentAgent
  def run(payload)
    # Make post request
    payload[:response_status] = '201'
  end
end
weather_fulfillment_agent = WeatherFulfillmentAgent.new
weather_sub_contracts = [temp_contract]
weather_contract = IhliTL::Contract.new(
  {}, 
  weather_fulfillment_agent, 
  weather_clauses,
  weather_sub_contracts
)

puts weather_contract.resolve({})

