
class TuringMachine
  class Program
    attr_accessor :states

    def initialize states = []
      @states = []
      @state = nil
      self.states = states
    end

    def states= states
      states.each { |s| self << s }
    end

    def << state
      @states << state
      state
    end

    def run head, &block
      head.state = states[0]
      if block_given?
        run_with_block head, &block
      else
        while step(head); end
      end      
    end

    def step head
      head.state.rules.each { |rule|
        if rule.condition_satisfied?(head.read)
          rule.apply(head)
          return rule
        end
      }
      nil
    end

  protected

    def run_with_block head, &block
      while step(head)
        block.call()
      end
      nil
    end
  end
end