
# forward support of ruby 1.9 feature

unless Object.instance_methods.include?('tap')
  class Object
    def tap
      yield self
      self
    end
  end
end

here = File.dirname(__FILE__)

require here+'/state'
require here+'/rule'
require here+'/program'
require here+'/tape'
require here+'/head'


class TuringMachine

  attr_accessor :tapes

  def initialize
    @tapes = []
  end

  def << tape
    @tapes << tape
    tape
  end
end
