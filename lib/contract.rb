module IhliTL
  class Contract
    def initialize(subject)
      @subject = subject
    end

    def resolve
      verify(perform_work(@subject))
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
