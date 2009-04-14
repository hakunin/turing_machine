
require File.dirname(__FILE__)+'/turing_machine'
require 'test/unit'

class TuringMachine
  class StateTest < Test::Unit::TestCase
    def test_state_contains_rules
      s = State.new
      r = s << Rule.new
      assert_equal [r], s.rules
    end

    def test_add_rule_returns_the_rule
      s = State.new
      rule = Rule.new
      assert_equal rule, s << rule
    end
  end
end