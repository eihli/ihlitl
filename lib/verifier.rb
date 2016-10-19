module IhliTL
  class Verifier
    class << self
      def verify(assertion, subject)
        msgs = assertion[:msg_chain]
        args = assertion[:args]
        calls = msgs.zip(args)
        initial = subject.send(calls[0][0], *calls[0][1])
        actual_value = calls[1..-1].reduce(initial) do |call|
          subject.send(call[0], *call[1])
        end

        send(assertion[:comparator], assertion[:value], actual_value)
      end

      def ==(expected, actual)
        expected == actual
      end
    end
  end
end
