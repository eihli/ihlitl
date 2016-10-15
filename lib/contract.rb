module IhliTL
  class Contract
    def initialize(subject)
      @subject = subject
    end

    def resolve
      if verify(perform_work(@subject))
        @subject
      else
        raise "Contract Error"
      end
    end

    def verify(subject)
      clauses.map do |clause|
        clause.call(subject)
      end
      subject
    end

    def perform_work(subject)
      subject
    end

    def clauses
      []
    end
  end
end
