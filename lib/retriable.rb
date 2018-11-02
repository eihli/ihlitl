class Retriable
  def initialize(retriable, attempt_method, failure_method, conditions)
    self.class.class_eval do
      define_method(attempt_method) {
        puts "Trying to perform #{attempt_method} on #{retriable}"
        puts "Checking exit conditions."
        if check(conditions).any? { |condition| condition }
          puts "Some exit condition was true. Calling some failure callback."
          retriable.send(failure_method)
        else
          puts "No exit conditions evaluated to true."
          puts "Trying to do something that might fail."
          if retriable.send(attempt_method)
            puts "It worked. We can stop trying."
          else
            puts "It didn't work. We're trying again."
            send(attempt_method)
          end
        end
      }
    end
  end

  def check(conditions)
    conditions.map do |condition|
      result = condition[:predicate].call(*condition[:args])
      condition[:after].call(condition)
      result
    end
  end
end

