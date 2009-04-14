
require File.dirname(__FILE__)+'/turing_machine'
require 'test/unit'

class TuringMachine
  class RuleTest < Test::Unit::TestCase
    def test_condition_satisfied_calls_if_with_char
      i = Rule.new({
        :if => lambda{ |char| char == 'a' },
      })
      assert i.condition_satisfied?('a')
      assert !(i.condition_satisfied?('b'))
    end

    def test_use_equal_condition_if_not_callable
      i = Rule.new({
        :if => 'a'
      })
      assert i.condition_satisfied?('a')
      assert !(i.condition_satisfied?('b'))
    end

    def test_move_defaults_to_move_command
      i = Rule.new({
        :move => 1
      })
      assert_equal Rule::MoveCommand.new(1), i.command
    end

    def test_rule_can_change_the_tape
      p = Program.new [
        State.new [
          Rule.new :if => 'a', :move => 1, :put => 'A'
        ]
      ]
      tape = Tape.new %w{a a}
      head = Head.new
      tape << head
      p.run(head)
      assert_equal  %w{A A}, tape.values
    end
  end
end