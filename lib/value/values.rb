# -*- coding: utf-8 -*-

class Value::Values
  include Enumerable

  def initialize(*values)
    options = Hash === values.last ? values.pop : {}
    values.pop if @block = values.last.to_s.start_with?('&') ? values.last.to_s[1..-1].to_sym : nil
    values.pop if @splat = (values.last and values.last.to_s.start_with?('*')) ?
    values.last.to_s[1..-1].to_sym : nil
    required, optional = values.partition{ |e| not(Array === e) }
    @required = required.map(&:to_sym)
    @optional = optional.map{ |e| [e.first.to_sym, e.last] }
    all = to_a
    @comparable = Array === options[:comparable] ?
      options[:comparable].each{ |e|
        raise ArgumentError, '%p is not among comparable members %s' % [e, all.map(&:inspect).join(', ')] unless all.include?(e)
      } :
      all
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

  attr_reader :required, :optional, :splat, :block, :comparable
end
