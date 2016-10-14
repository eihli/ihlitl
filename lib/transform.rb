class Transform
  def initialize(destination, *args)
    # Pass in credentials or any pre-reqs/setup here
    @destination = destination
  end

  def run(payload)
    deliver(transform(payload))
  end

  private

  def deliver(payload)
    @destination.run payload
  end

  def transform(payload)
    # Perform some transform
    payload
  end
end

