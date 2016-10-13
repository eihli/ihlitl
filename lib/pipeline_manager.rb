class PipelineManager
  @pipeline = []
  @payload = {}

  class << self
    attr_accessor :pipeline, :payload

    def run
      deliver(process(payload))
    end

    def process(payload)
      pipeline.each do |line|
        transform = line[0]
        args = [payload].concat line[1..-1]
        payload = transform.run(*args)
      end
      payload
    end

    def deliver(payload)
      puts payload
    end
  end
end
