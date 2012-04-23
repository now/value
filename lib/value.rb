# -*- coding: utf-8 -*-

module Value
  def initialize(*arguments)
    raise ArgumentError,
      'wrong number of arguments (%d for %d)' %
        [arguments.length, values.required.length] if
          arguments.length < values.required.length
    raise ArgumentError,
      'wrong number of arguments (%d for %d)' %
        [arguments.length,
         values.required.length + values.optional.length] if
          arguments.length > values.required.length +
            values.optional.length and not values.splat
    instance_variable_set :"@#{values.block}",
      block_given? ? Proc.new : nil if values.block
    instance_variable_set :"@#{values.splat}",
      arguments[values.required.length +
                values.optional.length..-1] if values.splat
    values.required.each_with_index do |value, index|
      instance_variable_set :"@#{value}", arguments[index]
    end
    values.optional.each_with_index do |(value, default), index|
      offset = values.required.length + index
      instance_variable_set :"@#{value}",
        offset >= arguments.length ? default : arguments[offset]
    end
  end

  def ==(other)
    self.class == other.class and
      values.all?{ |value| send(value) == other.send(value) }
  end

  alias eql? ==

  def hash
    self.class.hash ^ values.map{ |value| send(value) }.hash
  end

  def inspect
    '%s.new(%s)' %
      [self.class,
       values.map{ |value| send(value).inspect }.join(', ')]
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

    def ==(other)
      self.class == other.class and
        required == other.required and
        optional == other.optional and
        splat == other.splat and
        block == other.block
    end

    attr_reader :required, :optional, :splat, :block
  end
end

class Module
  def Value(first, *rest)
    values = Value::Values.new(first, *rest)
    attr_reader(*values)
    protected(*values)
    define_method :values do
      values
    end
    private :values
    include Value
  end
end
