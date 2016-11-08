module IhliTL
  class Verifier
    class << self
      def verify(assertion, subject)
        @assertion = assertion
        msgs = assertion[:msg_chain] # [:[], :length]
        args = assertion[:args] # [[msg1_arg1, msg1_arg2], [msg2_arg1, msg2_arg2]]
        calls = msgs.zip(args)
        # calls --> [[:[], [msg1_arg1, msg1_arg2]], [:length], [nil]]
        initial = subject.send(calls[0][0], *calls[0][1])

        # Starting with the initial value...
        actual_value = calls[1..-1].reduce(initial) do |val, call|
          # ... send each message in the :msg_chain to the accumulated value, with :args
          if call[1] != nil
            val.send(call[0], *call[1])
          else
            val.send(call[0])
          end
        end
        generic_comparison(assertion[:comparator], assertion[:value], actual_value)
      end

      def generic_comparison(method_sym, expected, actual)
        # This works for any 'actual' that responds to the comparator (>, ==, <=, etc...) with the 'expected'
        # and returns a truthy/falsey value correctly.
        # More complex comparison methods could be added?
        if actual.send(method_sym, expected)
          true
        else
          "Error: actual #{actual} expected: #{expected} for #{@assertion[:msg_chain]}, #{@assertion[:args]}, #{@assertion[:comparator]}"
        end
      end
    end
  end
end
