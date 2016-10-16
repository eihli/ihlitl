module IhliTL
  class Contract
    def initialize(subject, transform)
      @subject = subject
      @transform = transform
      @errors = []
    end

    def resolve
      verified_subject = @transform.call(@subject)
      if verified_subject
        verified_subject
      else
        raise "Contract Error"
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
