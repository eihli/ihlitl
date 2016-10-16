module IhliTL
  class Contract
    def initialize(subject, transform)
      @subject = subject
      @transform = transform
      @errors = []
    end

    def resolve
      begin
        return @subject if verify(@subject)
      rescue
        transformed_subject = @transform.call(@subject)
        if verify(transformed_subject)
          transformed_subject
        else
          raise "Contract Error"
        end
      end
    end

    def verify(subject)
      @errors = clauses.map do |clause|
        if clause.call(subject)
          nil
        else
          "Validation failed on #{clause}"
        end
      end
      @errors.compact.empty?
    end

    def clauses
      []
    end
  end
end
