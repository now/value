# -*- coding: utf-8 -*-

# Represents an immutable [value
# object](http://en.wikipedia.org/wiki/Value_object) with an {#initialize}
# method, equality checks {#==} and {#eql?}, a {#hash} function, and an
# {#inspect} method.
#
# @example A Point Value Object
#   class Point
#     Value :x, :y
#   end
#
# @example A Point Value Object with Public Accessors
#   class Point
#     Value :x, :y
#     public(*attributes)
#   end
#
# @example A Value Object with Optional Attributes
#   class Money
#     Value :amount, [:currency, :USD]
#   end
#
# @example A Value Object with a Comparable Attribute
#   class Vector
#     Value :a, :b, :comparable => :a
#   end
module Value
  # Creates a new value object, using ARGUMENTS to set up the value’s
  # {Attributes#required required}, {Attributes#optional optional}, and
  # {Attributes#splat splat} attributes, and the given block, if given,
  # if a {Attributes#block block} is desired.
  #
  # @param [Object, …] arguments
  # @raise [ArgumentError] If ARGUMENTS#length is less than the number of
  #   {Attributes#required required} attributes
  # @raise [ArgumentError] If ARGUMENTS#length is greater than the number of
  #   {Attributes#required required} and {Attributes#optional optional}
  #   attributes
  # @yield [?]
  def initialize(*arguments)
    raise ArgumentError,
      'wrong number of arguments (%d for %d)' %
        [arguments.length, attributes.required.length] if
          arguments.length < attributes.required.length
    raise ArgumentError,
      'wrong number of arguments (%d for %d)' %
        [arguments.length,
         attributes.required.length + attributes.optional.length] if
          arguments.length > attributes.required.length +
            attributes.optional.length and not attributes.splat
    instance_variable_set :"@#{attributes.block}",
      block_given? ? Proc.new : nil if attributes.block
    instance_variable_set :"@#{attributes.splat}",
      arguments[attributes.required.length +
                attributes.optional.length..-1] if attributes.splat
    attributes.required.each_with_index do |value, index|
      instance_variable_set :"@#{value}", arguments[index]
    end
    attributes.optional.each_with_index do |(value, default), index|
      offset = attributes.required.length + index
      instance_variable_set :"@#{value}",
        offset >= arguments.length ? default : arguments[offset]
    end
  end

  # @return [Boolean] True if the receiver’s class and all of its {Attributes}
  #   `#==` those of OTHER
  def ==(other)
    self.class == other.class and attributes.all?{ |e| send(e) == other.send(e) }
  end

  # (see #==)
  alias eql? ==

  # @return [Fixnum] The hash value of the receiver’s class XORed with the hash
  #   value of the Array of the values of the {Attributes} of the receiver
  def hash
    self.class.hash ^ attributes.map{ |e| send(e) }.hash
  end

  # @return [String] The inspection of the receiver
  def inspect
    '%s.new(%s)' %
      [self.class,
       [attributes.required.map{ |name| send(name).inspect },
        attributes.optional.
          map{ |name, default| [send(name), default] }.
          select{ |value, default| value != default or attributes.splat }.
          map{ |value, _| value },
        attributes.splat ? send(attributes.splat).map{ |value| value.inspect } : [],
        attributes.block ? ['&%s' % [send(attributes.block).inspect]] : []].
          flatten.join(', ')]
  end

  private

  def values
    warn "%s#%s: deprecated, use #attributes" % [self.class, __method__]
    attributes
  end

  load File.expand_path('../value/version.rb', __FILE__)
  Version.load
end

# Ruby’s Module class, extended to add {Module#Value #Value}, a way of creating
# value object classes.
class Module
  # @overload Value(first, *rest, options = {})
  #
  #   Marks the module as a {::Value} object with attributes FIRST and REST.
  #   This’ll add protected attribute readers for each of these attributes and
  #   a private method #attributes that returns the {Value::Attributes}
  #   themselves, include {Value::Comparable} if COMPARABLE isn’t falsy, and
  #   finally include {::Value}.
  #
  #   @param (see ::Value::Attributes#initialize)
  #   @option (see ::Value::Attributes#initialize)
  #   @raise (see ::Value::Attributes#initialize)
  def Value(first, *rest)
    options = Hash === rest.last ? rest.pop : {}
    attributes = Value::Attributes.new(first, *rest.dup.push({:comparable => options[:comparable]}))
    attr_reader(*attributes)
    protected(*attributes)
    define_method :attributes do
      attributes
    end
    private :attributes
    include Value::Comparable if options[:comparable]
    include Value
    self
  end
end
