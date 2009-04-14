
class TuringMachine
  class Tape
    def initialize values = []
      self.values = values
    end

    def << head
      head.tap { |h| h.tape = self }
    end

    def values= values = []
      i = -1
      @chars =
        Hash[*values.collect{ |item|
          i += 1; [i, item]
        }.flatten]
#      i = 0
#      @chars = InsertOrderPreservingHash.new
#      values.collect{ |item|
#        @chars[i] = item
#        i += 1
#      }
    end

    def values
      @chars.to_a.sort { |a, b| a[0] <=> b[0] }.collect { |i| i[1] }
    end

    def value_at position
      @chars[position]
    end

    def set_value_at index, value
      @chars[index] = value
    end
  end



  class InsertOrderPreservingHash
    include Enumerable

    def initialize(*args, &block)
      @h = Hash.new(*args, &block)
      @ordered_keys = []
    end

    def []=(key, val)
      @ordered_keys << key unless @h.has_key? key
      @h[key] = val
    end

    def each
      @ordered_keys.each {|k| yield(k, @h[k])}
    end
    alias :each_pair :each

    def each_value
      @ordered_keys.each {|k| yield(@h[k])}
    end

    def each_key
      @ordered_keys.each {|k| yield k}
    end

    def keys
      @ordered_keys
    end

    def values
      @ordered_keys.map {|k| @h[k]}
    end

    def clear
      @ordered_keys.clear
      @h.clear
    end

    def delete(k, &block)
      @ordered_keys.delete k
      @h.delete(k, &block)
    end

    def reject!
      del = []
      each_pair {|k,v| del << k if yield k,v}
      del.each {|k| delete k}
      del.empty? ? nil : self
    end

    def delete_if(&block)
      reject!(&block)
      self
    end

    %w(merge!).each do |name|
      define_method(name) do |*args|
        raise NotImplementedError, "#{name} not implemented"
      end
    end

    def method_missing(*args)
      @h.send(*args)
    end
  end
end