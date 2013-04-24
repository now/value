# -*- coding: utf-8 -*-

# Keeps track of the structure of the attributes associated with a {Value}
# object.  This is an ordered set of {#required}, {#optional}, {#splat}, and
# {#block} arguments to the value object’s {Value#initialize initialize}
# method, some or all of which may be {#comparable}.
class Value::Attributes
  include Enumerable

  # @overload initialize(first, *rest, options = {})
  #
  #   Sets up a {Value} objects attributes FIRST and REST.  If the last
  #   attribute starts with ‘&’, then the value object’s {Value#initialize
  #   initialize} method may take an optional block.  If the last or second to
  #   last, depending on the previous sentence, attribute starts with ‘*’, then
  #   the value object’s {Value#initialize initialize} method may take a splat
  #   argument.  The rest of the attributes are split at the first element
  #   that’s an Array.  All attributes before this element are required
  #   arguments to the value object’s {Value#initialize initialize} method.
  #   The first element that’s an Array and all following elements, which
  #   should also be Arrays, are optional arguments to the value object’s
  #   {Value#initialize initialize} method, where the first element of these
  #   Arrays is the attribute and the last element is its default value.
  #
  #   @param [Symbol, Array<Symbol, Object>] first
  #   @param [Array<Symbol, Array<Symbol, Object>>] rest
  #   @param [Hash] options
  #   @option options [Array<Symbol>, Boolean, nil] :comparable (nil) The
  #     subset of first and rest that should be used for comparing instances of
  #     this value object class, or a truthy value to use the whole set, or a
  #     falsy value to use an empty set
  #   @raise [ArgumentError] If any element of COMPARABLE isn’t an element of
  #     first and rest
  def initialize(first, *rest)
    options = Hash === rest.last ? rest.pop : {}
    names = [first] + rest
    names.pop if @block = names.last.to_s.start_with?('&') ?
      names.last.to_s[1..-1].to_sym : nil
    names.pop if @splat = (names.last and names.last.to_s.start_with?('*')) ?
      names.last.to_s[1..-1].to_sym : nil
    @required = names.take_while{ |e| not(Array === e) }.map(&:to_sym)
    @optional = names[required.length..-1].map{ |e| [e.first.to_sym, e.last] }
    all = to_a
    @comparable =
      case options[:comparable]
      when Array
        options[:comparable].each{ |e|
          raise ArgumentError, '%p is not among comparable members %s' %
            [e, all.map(&:inspect).join(', ')] unless all.include?(e)
        }
      when false, nil
        []
      else
        all
      end
  end

  # @overload
  #   Enumerates the attributes.
  #
  #   @yieldparam [Symbol] attribute
  # @overload
  #   @return [Enumerator<Symbol>] An Enumerator over the attributes
  def each
    return enum_for(__method__) unless block_given?
    required.each do |name|
      yield name
    end
    optional.each do |name, _|
      yield name
    end
    yield splat if splat
    yield block if block
    self
  end

  # @return [Boolean] True if the receiver’s class and its required, optional,
  #   splat, and block attributes `#==` those of OTHER
  def ==(other)
    self.class == other.class and
      required == other.required and
      optional == other.optional and
      splat == other.splat and
      block == other.block
  end

  # @return [Array<Symbol>] The required attributes
  attr_reader :required

  # @return [Array<Array<Symbol, Object>>] The optional attributes and their
  #   defaults
  attr_reader :optional

  # @return [Symbol, nil] The splat attribute
  attr_reader :splat

  # @return [Symbol, nil] The block attribute
  attr_reader :block

  # @return [Array<Symbol>] The comparable attributes
  attr_reader :comparable
end
