# -*- coding: utf-8 -*-

module Value::Comparable
  include Comparable

  def <=>(other)
    return nil unless self.class == other.class
    v = nil
    (values.comparable.any?{ |e| v = (send(e) <=> other.send(e)).nonzero? } and v) or 0
  end

  alias eql? ==
end
