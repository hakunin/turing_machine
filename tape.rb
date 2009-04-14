
class TuringMachine
  class Tape
    def initialize values = []
      self.values = values
    end

    def << head
      head.tap { |h| h.tape = self }
    end

    def values= values = []
      i = -1
      @chars =
        Hash[*values.collect{ |item|
          i += 1; [i, item]
        }.flatten]
    end

    def values
      @chars.values
    end

    def value_at position
      @chars[position]
    end

    def set_value_at index, value
      @chars[index] = value
    end
  end
end