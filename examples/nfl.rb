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

# class WeatherContract < IhliTL::Contract
#   def clauses
#     [
#       -> (subject) {
#         subject[:zip_code].length == 5 &&
#         Float(subject[:temp_f]) &&
#         subject[:response_status] == '200'
#       }
#     ]
#   end
# end
# 
# class WeatherTransform < IhliTL::Transform
#   def transform(payload)
#     payload.merge!(ZipCodeContract.new(payload, -> (payload) {
#       ZipCodeTransform.new.transform(payload)
#     }).resolve)
# 
#     payload.merge!(TemperatureContract.new({zip_code: '94110'}, -> (payload) {
#       TemperatureTransform.new.transform(payload)
#     }).resolve)
# 
#     response = send_response_to_external_api
#     payload[:response_status] = response
#     payload
#   end
# 
#   def send_response_to_external_api
#     '200'
#   end
# end
# 
# class TemperatureContract < IhliTL::Contract
#   def clauses
#     [
#       -> (subject) { temperature_clause(subject) }
#     ]
#   end
# 
#   def temperature_clause(subject)
#     puts "Verifying weather"
#     Float(subject[:temp_f]).class == Float
#   end
# end
# 
# class ZipCodeContract < IhliTL::Contract
#   def clauses
#     [
#       -> (subject) { zip_code_clause(subject) }
#     ]
#   end
# 
#   def zip_code_clause(subject)
#     puts "Verifying Zip Code"
#     Integer(subject[:zip_code]) &&
#       subject[:zip_code].length == 5
#   end
# end
# 
# class ZipCodeTransform < IhliTL::Transform
#   def transform(payload)
#     puts "Transforming Zip Code"
#     payload[:zip_code] = '90210'
#     payload
#   end
# end
# 
# class TemperatureTransform < IhliTL::Transform
#   def transform(payload)
#     payload = ZipCodeContract.new(payload, -> (payload) {
#       ZipCodeTransform.new.transform(payload)
#     }).resolve
# 
#     puts "Transforming Weather"
#     payload[:temp_f] = '5'
#     payload
#   end
# end
# 
# class OutboundTransform < IhliTL::Transform
#   def transform(payload)
#   end
# end
# 
# foo = WeatherContract.new({}, -> (payload) {
#   WeatherTransform.new.transform(payload)
# })
# 
# puts foo.resolve
