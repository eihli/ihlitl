require_relative '../lib/pipeline_manager'

class NFLTransform
  class << self
    def run(payload, api_key)
      payload[:game_id] = 1
      payload[:called_with_api_key] = api_key
      payload
    end
  end
end

class NFLPipelineManager < PipelineManager
  @payload = {}
  @pipeline = [
    [NFLTransform, '12345']
  ]
end

NFLPipelineManager.run
