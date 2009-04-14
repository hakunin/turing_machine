
class TuringMachine
  class Program
    attr_accessor :states, :start_state

    def initialize states = nil
      @states = nil
      @state = nil
      self.states = states
    end

    def []= k, v
      unless @states
        @start_state = v
        @states = {}
      end
      @states[k] = v
      v
    end

    def [] k
      @states[k]
    end


    def run head, max_iterations = nil, &block
      unless head.state = @start_state
        raise 'No start state given.'
      end
      iteration = 0;
      
      while step(head)
        if block
          block.call()
        end
        if max_iterations
          iteration += 1;
          if iteration >= max_iterations
            return head.state
          end
        end
      end
      nil
    end

    def step head
      head.state.rules.each { |rule|
        if rule.condition_satisfied?(head.read)
          rule.apply(head, self)
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