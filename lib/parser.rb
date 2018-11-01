module IhliTL
  class Parser
    class << self
      def parse(definition)
        agent = definition[:class].new(*definition[:args])
        definition[:definitions].each do |definition|
          agent.add(parse(definition))
        end
        agent
      end
    end
  end
end
