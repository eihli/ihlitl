require 'http'
require_relative '../lib/exceptions'
require_relative '../lib/transform'
require_relative '../lib/destination'
require_relative '../lib/pipeline_manager'

class NFLTransform < IhliTL::Transform
  def initialize(destination, api_key)
    @api_key = api_key
    super
  end

  def transform(payload)
    payload[:game_id] = 1
    payload[:called_with_api_key] = @api_key
    payload
  end
end

class WeatherTransform < IhliTL::Transform
  def initialize(destination, api_key)
    @api_key = api_key
    super
  end

  def transform(payload)
    payload[:temp_f] =  response_json["current_observation"]["temp_f"]
    raise IhliTL::TransformError.new(self, payload)
    payload
  end

  private

  def api_url
    "http://api.wunderground.com/api/#{@api_key}/conditions/q/CA/San_Francisco.json"
  end

  def response_json
    JSON.parse(HTTP.get(api_url))
  end
end

# Inherit from Destination?
class SomeDestination < IhliTL::Destination
  def deliver(payload)
    puts 'Delivery sent!'
    puts payload
  end
end

class NFLPipelineManager < IhliTL::PipelineManager
  def deliver(payload)
    SomeDestination.deliver(payload)
  end
end

weather_api_key = '4aaeba74af287db4'

pipeline = [
  [NFLTransform, '12345'],
  [WeatherTransform, weather_api_key],
  [SomeDestination]
]

pipeline_manager = NFLPipelineManager.new pipeline, {}

pipeline_manager.run
