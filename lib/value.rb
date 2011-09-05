# -*- coding: utf-8 -*-

class Value
  autoload :Version, 'value/version'

  class << self
    def values(*values)
      if values.empty?
        raise RuntimeError,
          'no values have been set for class: %p' % self if not defined? @values
        @values
      else
        @values ||= []
        @values.concat values.map{ |value| value.to_sym }.tap{ |symbols|
          attr_reader(*symbols)
          protected(*symbols)
        }
      end
    end
  end

  def initialize(*arguments)
    raise ArgumentError,
      'wrong number of arguments (%d for %d)' %
        [arguments.length, self.class.values.length] if
          arguments.length != self.class.values.length
    self.class.values.each_with_index do |value, index|
      instance_variable_set :"@#{value}", arguments[index]
    end
    freeze
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
end
