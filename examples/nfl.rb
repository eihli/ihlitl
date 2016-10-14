require_relative '../lib/transform'
require_relative '../lib/destination'
require_relative '../lib/pipeline_manager'

class NFLTransform < Transform
  def initialize(destination, api_key)
    @api_key
    super
  end

  def transform(payload)
    payload[:game_id] = 1
    payload[:called_with_api_key] = @api_key
    payload
  end
end

class WeatherTransform < Transform
  def initialize(destination, username, password)
    @username = username
    @password = password
    super
  end

  def transform(payload)
    payload[:temp_f] = '66.5'
    payload[:credentials] = {username: @username, password: @password}
    payload
  end
end

# Inherit from Destination?
class SomeDestination < Destination
  def deliver(payload)
    puts 'Delivery sent!'
    puts payload
  end
end

class NFLPipelineManager < PipelineManager
  def deliver(payload)
    SomeDestination.deliver(payload)
  end
end

pipeline = [
  [NFLTransform, '12345'],
  [WeatherTransform, 'some_username', 'some_password'],
  [SomeDestination]
]

pipeline_manager = NFLPipelineManager.new pipeline, {}

pipeline_manager.run
