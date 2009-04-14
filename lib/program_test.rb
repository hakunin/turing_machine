
require File.dirname(__FILE__)+'/turing_machine'
require 'test/unit'

class TuringMachine
  class ProgramTest < Test::Unit::TestCase
    def test_program_contains_state_hash
      program = Program.new
      s = program[:state] = State.new
      assert_equal({:state => s}, program.states)
    end

    def test_program_max_iterations
      p = Program.new
      p[:start] = State.new([
          Rule.new :if => 'a', :move => 1
        ])
      tape = Tape.new %w{a a a a a a}
      head = tape << Head.new
      iteration = 0
      p.run(head, 3) do
        iteration += 1
      end
      assert_equal 3, iteration
    end

    def test_step_uses_rules_to_move_the_head
      program = Program.new
      state = State.new
      state << Rule.new(:if => 'a', :move => 1)
      #state << Rule.new(:if => nil, :move => 1)
      program[:start] = state

      tape = Tape.new %w{a b c}
      head = tape << Head.new
      head.state = program.states[:start]

      assert_equal 0, head.position
      assert_equal 'a', head.read

      program.step(head)
      assert_equal 1, head.position

      program.step(head)
      assert_equal 1, head.position
    end

    def test_step_changes_states
      program = Program.new

      forth = (program[:forth] = State.new [
        Rule.new(:if => 'a', :move => 1),
        Rule.new(:if => nil, :move => -1, :go => :back)
      ])

      back = (program[:back] = State.new [
        Rule.new(:if => 'a', :move => -1)
      ])

      tape = Tape.new %w{a a}
      head = tape << Head.new
      head.state = program.start_state

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

    def test_first_state_defined_is_starting
      program = Program.new
      start = State.new []
      program[:forth] = start
      assert_equal start, program.start_state
    end

    def test_run
      program = Program.new

      program[:forth] = State.new [
        Rule.new(:if => 'a', :move => 1),
        Rule.new(:if => nil, :move => -1, :go => :back)
      ]
      
      program[:back] = State.new [
        Rule.new(:if => 'a', :move => -1)
      ]      

      tape = Tape.new %w{a a}
      head = tape << Head.new

      program.run(head)

      assert_equal -1, head.position
    end

    def test_run_with_block_makes_around_filter

      program = Program.new

      program[:forth] = State.new [
        Rule.new(:if => 'a', :move => 1),
        Rule.new(:if => nil, :move => -1, :go => :back)
      ]

      program[:back] = State.new [
        Rule.new(:if => 'a', :move => -1)
      ]   

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