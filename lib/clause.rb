class Clause
  class ClauseError < StandardError; end

  attr_reader :description
  def initialize(subject, description, options)
    @subject = subject
    @description = description
    @options = options
  end

  def verify
    errors = []
    @options.each do |option|
      result = evaluate(option)
      if result == true
      elsif result == false
        subject_value = @subject.send(option[:accessor].to_sym, option[:property].to_sym)
        errors << "Error: expected #{option[:comparator]}, #{subject_value}, #{option[:value]} with subject #{@subject}"
      else
        # If it's not true or false, it's an exception
        errors << result
      end
      errors
    end
    return errors unless errors.empty?
    true
  end

  def evaluate(option)
    begin
      @subject.send(option[:accessor].to_sym, option[:property].to_sym).send(option[:comparator].to_sym, option[:value])
    rescue => e
      e
    end
  end
end

