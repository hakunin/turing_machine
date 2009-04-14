
class TuringMachine
  class Rule

    attr_accessor :condition, :command, :switch_state

    def initialize attrs = {}
      set attrs
    end

    def condition_satisfied? char = {}
      @condition.call(char)
    end

    def set hash
      @condition = make_condition(hash[:if])
      @command = make_command(hash[:move])
      if hash.has_key? :put
        @put = hash[:put]
        @put_set = true
      end
      @switch_state = hash[:go]
    end

    def apply head
      command.call head
      if switch_state
        head.state = switch_state
      end
      if @put_set
        head.write = @put
      end
    end

    def inspect
      {
        :if => @condition,
        :do => @command,
        :put => @put,
        :go => @switch_state
      }.inspect
    end

  protected

    def make_command c
      if c.respond_to? :call
        c
      else
        MoveCommand.new c
      end
    end

    def make_condition c
      if c.respond_to? :call
        c
      else
        EqualCondition.new c
      end
    end

    class EqualCondition
      def initialize o
        @must_equal = o
      end

      def call o
        @must_equal == o
      end

      def inspect
        "== #{@must_equal}"
      end

    end

    class MoveCommand
      attr_accessor :args

      def initialize *args
        @args = args
      end

      def call head
        head.move(*@args)
      end

      def == other
        args == other.args
      end

      def inspect
        "move #{@args}"
      end
    end
  end
end
