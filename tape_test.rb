
require File.dirname(__FILE__)+'/turing_machine'
require 'test/unit'

class TuringMachine
  class TapeTest < Test::Unit::TestCase

    def test_tape_creation_with_array
      assert_equal %w{a b c d}, Tape.new(%w{a b c d}).values
    end

    def test_tape_value_at_returns_values
      assert_equal 'a', Tape.new(%w{a b c d}).value_at(0)
    end

    def test_add_head_returns_head
      tape = Tape.new
      head = Head.new
      assert_equal head, tape << head
    end

    def test_set_heas_tape_after_addition
      tape = Tape.new()
      head = tape << Head.new
      assert_equal tape, head.tape
    end

    def test_not_set_values_return_nil
      assert_equal nil, Tape.new().value_at(0)
      assert_equal nil, Tape.new(%w{a b c}).value_at(-1)
      assert_equal nil, Tape.new(%w{a b c}).value_at(3)
    end
  end
end