module IhliTL
  class Contract
    def initialize(subject)
      @subject = subject
      @errors = []
    end

    def resolve
      if verify(perform_work(@subject))
        @subject
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

    def perform_work(subject)
      subject
    end

    def clauses
      []
    end
  end
end
