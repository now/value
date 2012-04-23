# -*- coding: utf-8 -*-

Expectations do
  expect 0 do
    c = Class.new{ Value(:a, :comparable => true) }
    c.new(1) <=> c.new(1)
  end

  expect 0 do
    c = Class.new{ Value(:a, :b, :comparable => [:a]) }
    c.new(1, 2) <=> c.new(1, 3)
  end

  expect ArgumentError.new(':c is not among comparable members :a, :b') do
    Class.new{ Value(:a, :b, :comparable => [:c]) }
  end
end
