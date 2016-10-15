module IhliTL
  class DeliverRetriable
    def initialize(deliverable, max_delivery_attempts)
      @deliverable = deliverable
      @max_delivery_attempts
    end

    def deliver(delivery_attempt = 0, *args)
      if delivery_attempt > @max_delivery_attempts
        puts "Delivery attempts too great to handle"
      else
        super(delivery_attempt + 1, *args)
      end
    end
  end
end

