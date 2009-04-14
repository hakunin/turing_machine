
require File.dirname(__FILE__)+'/turing_machine'
require 'test/unit'

class TuringMachine
  class HeadTest < Test::Unit::TestCase

    def test_head_position_is_zero_after_creation
      tape = Tape.new
      head = tape << Head.new
      assert_equal 0, head.position
    end

    def test_head_movement
      tape = Tape.new
      head = tape << Head.new
      pos = head.position
      head.move 1
      assert_equal pos+1, head.position
    end

    def test_head_reads_tape
      tape = Tape.new(%w{a b c d})
      head = tape << Head.new
      assert_equal 'a', head.read
      head.move 1
      assert_equal 'b', head.read
      head.move -1
      assert_equal 'a', head.read
    end

    def test_head_writes_to_tape
      tape = Tape.new()
      head = tape << Head.new
      head.write 'a'
      assert_equal %w{a},tape.values
    end
  end
end