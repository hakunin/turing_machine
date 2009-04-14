
class TuringMachine
  class Head
    attr_accessor :position, :tape, :state

    def initialize
      @position = 0
    end

    def move delta
      @position += delta
    end

    def read
      tape.value_at(@position)
    end

    def write color
      tape.set_value_at(@position, color)
    end
  end
end