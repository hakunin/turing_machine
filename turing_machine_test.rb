require 'test/unit'
require File.dirname(__FILE__) +'/turing_machine'

class TuringMachine

  class TuringMachineTest < Test::Unit::TestCase

    def test_create_tape
      tm = TuringMachine.new
      tape = tm << Tape.new
      assert_equal [tape], tm.tapes
    end

    def test_add_tape_returns_tape
      tm = TuringMachine.new
      tape = Tape.new
      assert_equal tape, tm << tape
    end
  end

  class ProgramTest < Test::Unit::TestCase
    def test_create_instructions_for_machine
      is = Program.new()
    end
  end


end