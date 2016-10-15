class Deliverable
  def deliver(payload)
    puts payload
  end
end

def attempt_to_do_something
  rand(10) > 8
end

class Retriable
  def initialize(retriable, method, conditions)
    @retriable = retriable
    @method = method
    @conditions = conditions
  end

  def check_conditions
    @conditions.map do |condition|
      puts condition
      result = condition[:predicate].call(*condition[:args])
      condition[:after].call(condition)
      result
    end
  end
end

conditions = [
  {
    args: [0, 5],
    predicate: -> (attempt, max_attempts) { attempt > max_attempts },
    after: -> (condition) { condition[:args][0] += 1 }
  }
]
retriable = Retriable.new({}, {}, conditions)
puts retriable.check_conditions

class Retriable
  def initialize(deliverable, max_attempts)
    @deliverable = deliverable
    @max_attempts = max_attempts
  end

  def deliver(attempt = 0, *args)
    if attempt.class == Hash
      *args = attempt
      attempt = 0
    end

    if attempt > @max_attempts
      puts "We broke"
    else
      if attempt_to_do_something
        puts "Delivery successful on attempt #{attempt}"
      else
        deliver(attempt + 1, *args)
      end
    end
  end
end


delivery = Deliverable.new
retriable_delivery = Retriable.new(delivery, 5)

retriable_delivery.deliver({name: 'eric'})
retriable_delivery.deliver({name: 'eric'})
retriable_delivery.deliver({name: 'eric'})
retriable_delivery.deliver({name: 'eric'})
retriable_delivery.deliver({name: 'eric'})
retriable_delivery.deliver({name: 'eric'})
