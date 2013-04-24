# -*- coding: utf-8 -*-

# Module included by {Module#Value} when passed the :comparable option.
module Value::Comparable
  include ::Comparable

  # @return [Integer, nil] The first non-zero comparison of the
  #   {Attributes#comparable} values of the receiver with those of OTHER (zero
  #   if they’re all equal), or nil if the #class of the receiver doesn’t `#==`
  #   that of OTHER
  def <=>(other)
    return nil unless self.class == other.class
    v = nil
    (attributes.comparable.any?{ |e| v = (send(e) <=> other.send(e)).nonzero? } and v) or 0
  end

  # (see #==)
  alias eql? ==
end
