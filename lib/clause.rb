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
    begin
      @options.each do |option|
        unless evaluate(option)
          suject_value = @subject.send(option[:accessor], option[:property])
          errors << "Error: expected #{option[:comparator]}, #{subject_value}, #{option[:value]} with subject #{@subject}"
        end
      end
      errors
    rescue => e
      errors << e
    end
  end

  def evaluate(option)
    @subject.send(option[:accessor]).send(option[:comparator], option[:property])
  end
end

