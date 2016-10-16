module IhliTL
  class Contract
    def initialize(subject)
      @subject = subject
      @errors = []
    end

    def resolve
      if verify(@subject)
        @subject
      else
        raise
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
