# -*- coding: utf-8 -*-

module Value
  def initialize(*arguments)
    raise ArgumentError,
      'wrong number of arguments (%d for %d)' %
        [arguments.length, self.class.values.required.length] if
          arguments.length < self.class.values.required.length
    raise ArgumentError,
      'wrong number of arguments (%d for %d)' %
        [arguments.length,
         self.class.values.required.length + self.class.values.optional.length] if
          arguments.length > self.class.values.required.length +
            self.class.values.optional.length and not self.class.values.splat
    instance_variable_set :"@#{self.class.values.block}",
      block_given? ? Proc.new : nil if self.class.values.block
    instance_variable_set :"@#{self.class.values.splat}",
      arguments[self.class.values.required.length +
                self.class.values.optional.length..-1] if self.class.values.splat
    self.class.values.required.each_with_index do |value, index|
      instance_variable_set :"@#{value}", arguments[index]
    end
    self.class.values.optional.each_with_index do |(value, default), index|
      offset = self.class.values.required.length + index
      instance_variable_set :"@#{value}",
        offset >= arguments.length ? default : arguments[offset]
    end
  end

  def ==(other)
    self.class == other.class and
      self.class.values.all?{ |value| send(value) == other.send(value) }
  end

  alias eql? ==

  def hash
    self.class.hash ^ self.class.values.map{ |value| send(value) }.hash
  end

  def inspect
    '%s.new(%s)' %
      [self.class,
       self.class.values.map{ |value| send(value).inspect }.join(', ')]
  end

  class Values
    include Enumerable

    def initialize(*values)
      values.pop if @block = values.last.to_s.start_with?('&') ? values.last.to_s[1..-1].to_sym : nil
      values.pop if @splat = (values.last and values.last.to_s.start_with?('*')) ?
        values.last.to_s[1..-1].to_sym : nil
      required, optional = values.partition{ |e| not(Array === e) }
      @required = required.map(&:to_sym)
      @optional = optional.map{ |e| [e.first.to_sym, e.last] }
    end

    def each
      return enum_for(__method__) unless block_given?
      required.each do |value|
        yield value
      end
      optional.each do |value, _|
        yield value
      end
      yield splat if splat
      yield block if block
      self
    end

    attr_reader :required, :optional, :splat, :block
  end
end

class Module
  def Value(first, *rest)
    instance_variable_set :@values, Value::Values.new(first, *rest).tap{ |values|
      attr_reader(*values)
      protected(*values)
    }
    (class << self; self; end).instance_eval do
      attr_reader :values
    end
    include Value
  end
end
