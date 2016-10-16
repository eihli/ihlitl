require_relative './exceptions'

class Clause
  attr_reader :description

  def initialize(subject, description, options)
    @subject = subject
    @description = description
    @options = options
  end

  def verify
    errors = []
    @options.each do |option|
      begin
        result = evaluate(option)
      rescue IhliTL::ClauseError => e
        errors << e
      end

      if result == false
        subject_value = @subject.send(
          option[:accessor].to_sym,
          option[:property].to_sym
        )
        errors << "Error: expected #{option[:comparator]}, #{subject_value}, #{option[:value]} with subject #{@subject}"
      end
    end
    return errors unless errors.empty?
    true
  end

  def evaluate(option)
    begin
      if @subject.send(option[:accessor].to_sym, option[:property].to_sym).send(option[:comparator].to_sym, option[:value])
        true
      else
        false
      end
    rescue => e
      raise IhliTL::ClauseError.new e
    end
  end
end

