require_relative './exceptions'

module IhliTL
  class Clause
    attr_reader :description, :options

    def initialize(description, options)
      @description = description
      @options = options
    end

    def verify(subject)
      errors = []

      @options.each do |option|
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
        if subject.send(option[:accessor].to_sym, option[:property].to_sym).send(option[:comparator].to_sym, option[:value])
          true
        else
          subject_value = subject.send(
            option[:accessor].to_sym,
            option[:property].to_sym
          )
          IhliTL::ClauseError.new "Error: #{option[:comparator]}, #{subject}, #{option[:accessor]}, #{option[:value]} but got #{subject_value}"
        end
      rescue => e
        raise IhliTL::ClauseError.new e
      end
    end
  end
end
