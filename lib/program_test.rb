
require File.dirname(__FILE__)+'/turing_machine'
require 'test/unit'

class TuringMachine
  class ProgramTest < Test::Unit::TestCase
    def test_program_contains_states
      program = Program.new
      s = program << State.new
      assert_equal [s], program.states
    end

    def test_step_uses_rules_to_move_the_head
      program = Program.new
      state = State.new
      state << Rule.new(:if => 'a', :move => 1)
      #state << Rule.new(:if => nil, :move => 1)
      program << state

      tape = Tape.new %w{a b c}
      head = tape << Head.new
      head.state = program.states[0]

      assert_equal 0, head.position
      assert_equal 'a', head.read

      program.step(head)
      assert_equal 1, head.position

      program.step(head)
      assert_equal 1, head.position
    end

    def test_step_changes_states
      program = Program.new

      back = State.new
      back << Rule.new(:if => 'a', :move => -1)

      forth = State.new
      forth << Rule.new(:if => 'a', :move => 1)
      forth << Rule.new(:if => nil, :move => -1, :go => back)
      
      program << forth
      program << back

      tape = Tape.new %w{a a}
      head = tape << Head.new
      head.state = program.states[0]

      assert_equal 0, head.position
      assert_equal 'a', head.read
      assert_equal forth, head.state

      program.step(head)
      assert_equal 1, head.position
      assert_equal forth, head.state

      program.step(head)
      assert_equal 2, head.position
      assert_equal forth, head.state

      program.step(head)
      assert_equal 1, head.position
      assert_equal back, head.state
      
      program.step(head)
      assert_equal 0, head.position
      assert_equal back, head.state

      program.step(head)
      assert_equal -1, head.position
      assert_equal back, head.state

      assert_equal nil, program.step(head)
    end

    def test_run
      program = Program.new

      back = State.new
      back << Rule.new(:if => 'a', :move => -1)

      forth = State.new
      forth << Rule.new(:if => 'a', :move => 1)
      forth << Rule.new(:if => nil, :move => -1, :go => back)

      program << forth
      program << back

      tape = Tape.new %w{a a}
      head = tape << Head.new

      program.run(head)

      assert_equal -1, head.position
    end

    def test_run_with_block_makes_around_filter

      program = Program.new

      back = State.new
      back << Rule.new(:if => 'a', :move => -1)

      forth = State.new
      forth << Rule.new(:if => 'a', :move => 1)
      forth << Rule.new(:if => nil, :move => -1, :go => back)

      program << forth
      program << back

      tape = Tape.new %w{a a}
      head = tape << Head.new

      steps = 0

      program.run(head) do
        steps += 1
      end

      assert_equal 5, steps
    end
  end
end