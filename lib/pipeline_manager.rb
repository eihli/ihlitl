class PipelineManager
  @pipeline = []
  @payload = {}

  class << self
    attr_accessor :pipeline, :payload

    def run
      pipeline.each do |line|
        args = line.concat [payload]
        transform = line[0]
        args = line[1..-1]
        payload = transform.run(*args)
      end

      deliver(payload)
    end

    def deliver(payload)
      puts payload
    end
  end
end
