
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
      p = Program.new
      p[:start] = State.new [
          Rule.new :if => 'a', :move => 1, :put => 'A'
        ]
      tape = Tape.new %w{a a}
      head = Head.new
      tape << head

      head.state = p[:start]

      assert_equal  %w{a a}, tape.values

      p.step(head)
      assert_equal  %w{A a}, tape.values

      p.step(head)
      assert_equal  %w{A A}, tape.values
    end

    def test_rule_can_change_the_state
      program = Program.new
      program[:forth] = State.new [
        Rule.new(:if => 'a', :move => 1),
        Rule.new(:if => nil, :move => -1, :go => :back)
      ]

      program[:back] = State.new [
        Rule.new(:if => 'a', :move => -1)
      ]

      tape = Tape.new
      head = tape << Head.new
      head.state = program.start_state
      
      assert program[:forth], head.state

      program.step head

      assert program[:back], head.state
    end
  end
end