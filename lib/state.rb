class TuringMachine
  class State
    attr_accessor :rules

    def initialize rules = []
      @rules = rules
    end

    def << rule
      @rules << rule
      rule
    end

    def inspect
      [@name, @rules].inspect
    end
  end
end