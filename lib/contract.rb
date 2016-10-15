module IhliTL
  class Contract
    def initialize(subject)
      @subject = subject
    end

    def resolve
      verify
    end

    def verify
      @subject
    end
  end
end
