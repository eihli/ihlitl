module IhliTL
  class Agent
    def initialize
      @agents = []
    end

    def add(agent)
      @agents << agent
    end

    def fulfill(subject)
      @agents.each do |agent|
        agent.fulfill(subject)
      end
    end
  end
end
