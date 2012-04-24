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

  load File.expand_path('../value/version.rb', __FILE__)
  Version.load
end

class Module
  def Value(first, *rest)
    options = Hash === rest.last ? rest.pop : {}
    values = Value::Values.new(*([first] + rest).push({:comparable => options[:comparable]}))
    attr_reader(*values)
    protected(*values)
    define_method :values do
      values
    end
    private :values
    include Value::Comparable if options[:comparable]
    include Value
  end
end
