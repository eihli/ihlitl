require_relative './exceptions'

module IhliTL
  class Clause
    attr_reader :name, :assertions

    def initialize(name = 'Default clause', assertions)
      @name = name
      @assertions = assertions
    end

    def verify(subject)
      errors = []

      @assertions.each do |option|
        begin
          result = evaluate(subject, option)
        rescue IhliTL::ClauseError => e
          errors << e
        end

        unless result == true
          errors << result
        end
      end
      return errors
    end

    def evaluate(subject, option)
      begin
        property = subject.send(option[:accessor].to_sym, option[:property].to_sym)

        if option[:attribute]
          actual_value = property.send(option[:attribute])
        else
          actual_value = property
        end
        expected_value = option[:value]

        if actual_value.send(option[:comparator].to_sym, expected_value)
          true
        else
          IhliTL::ClauseError.new "Error: #{option[:comparator]}, #{subject} #{option[:attribute]}, #{expected_value} but got #{actual_value}"
        end
      rescue => e
        raise IhliTL::ClauseError.new e
      end
    end
  end
end
