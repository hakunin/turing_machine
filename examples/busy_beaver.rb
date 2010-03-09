require File.dirname(__FILE__)+'/../lib/turing_machine'
 
class TuringMachine
 
  class BusyBeaver < Program
    def initialize
      super(
        :a => State.new([
          Rule.new(:if => 0, :move => -1, :put => 1,:go => :b),
          Rule.new(:if => 1, :move => 1, :put => 1,:go => :c)
        ]),
        :b => State.new([
          Rule.new(:if => 0, :move => -1, :put => 1,:go => :c),
          Rule.new(:if => 1, :move => -1, :put => 1, :go => :b)
        ]),
        :c => State.new([
          Rule.new(:if => 0, :move => -1, :put => 1, :go => :d),
          Rule.new(:if => 1, :move => 1, :put => 0, :go => :e)
        ]),
        :d => State.new([
          Rule.new(:if => 0, :move => 1, :put => 1,:go => :a),
          Rule.new(:if => 1, :move => 1, :put => 1,:go => :d)
        ]),
        :e => State.new([
          #Rule.new(:if => 0, :move => 1, :put => 1,:go => h),
          Rule.new(:if => 1, :move => 1, :put => 0,:go => :a)
        ])
      )
      self.start_state = self[:a]
    end
  end
 
  tape = Tape.new [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  head = tape << Head.new
  head.position = 12
 
  puts "Busy Beaver: http://en.wikipedia.org/wiki/Busy_beaver"
 
  BusyBeaver.new.run(head, 600) {
    puts tape.values.collect { |v| v == 1 ? '#' : '.' }.join
  }
 
end