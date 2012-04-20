# -*- coding: utf-8 -*-

Expectations do
  expect ArgumentError.new('wrong number of arguments (0 for 1)') do
    Class.new{ Value(:a) }.new
  end

  expect ArgumentError.new('wrong number of arguments (2 for 1)') do
    Class.new{ Value(:a) }.new(1, 2)
  end

  expect Value do
    Class.new{ Value(:a) }.new(1)
  end

  expect NoMethodError do
    Class.new{ Value(:a) }.new(1).a
  end

  expect 1 do
    Class.new{ Value(:a) }.new(1).instance_eval{ a }
  end

  expect 1 do
    Class.new{ Value(:a) }.new(1).instance_variable_get(:@a)
  end

  expect [] do
    Class.new{ Value(:'*a') }.new.instance_eval{ a }
  end

  expect [1, 2, 3] do
    Class.new{ Value(:'*a') }.new(1, 2, 3).instance_eval{ a }
  end

  expect ArgumentError.new('wrong number of arguments (0 for 1)') do
    Class.new{ Value(:a, :'*b') }.new
  end

  expect 1 do
    Class.new{ Value(:a, :'*b') }.new(1).instance_eval{ a }
  end

  expect [] do
    Class.new{ Value(:a, :'*b', :'&c') }.new(1).instance_eval{ b }
  end

  expect 1 do
    Class.new{ Value(:a, :'*b') }.new(1, 2, 3).instance_eval{ a }
  end

  expect [2, 3] do
    Class.new{ Value(:a, :'*b') }.new(1, 2, 3).instance_eval{ b }
  end

  expect nil do
    Class.new{ Value(:'&a') }.new.instance_eval{ a }
  end

  expect 1 do
    Class.new{ Value(:'&a') }.new{ 1 }.instance_eval{ a.call }
  end

  expect 1 do
    Class.new{ Value(:a, :'&b') }.new(1).instance_eval{ a }
  end

  expect nil do
    Class.new{ Value(:a, :'&b') }.new(1).instance_eval{ b }
  end

  expect 1 do
    Class.new{ Value(:a, :'&b') }.new(1){ 2 }.instance_eval{ a }
  end

  expect 2 do
    Class.new{ Value(:a, :'&b') }.new(1){ 2 }.instance_eval{ b.call }
  end

  expect 1 do
    Class.new{ Value(:a, :'*b', :'&c') }.new(1).instance_eval{ a }
  end

  expect [] do
    Class.new{ Value(:a, :'*b', :'&c') }.new(1).instance_eval{ b }
  end

  expect nil do
    Class.new{ Value(:a, :'*b', :'&c') }.new(1).instance_eval{ c }
  end

  expect 1 do
    Class.new{ Value(:a, :'*b', :'&c') }.new(1, 2, 3){ 4 }.instance_eval{ a }
  end

  expect [2, 3] do
    Class.new{ Value(:a, :'*b', :'&c') }.new(1, 2, 3){ 4 }.instance_eval{ b }
  end

  expect 4 do
    Class.new{ Value(:a, :'*b', :'&c') }.new(1, 2, 3){ 4 }.instance_eval{ c.call }
  end

  expect ArgumentError.new('wrong number of arguments (0 for 1)') do
    Class.new{ Value(:a, [:b, 2]) }.new
  end

  expect 1 do
    Class.new{ Value(:a, [:b, 2]) }.new(1).instance_eval{ a }
  end

  expect 2 do
    Class.new{ Value(:a, [:b, 2]) }.new(1).instance_eval{ b }
  end

  expect ArgumentError.new('wrong number of arguments (3 for 2)') do
    Class.new{ Value(:a, [:b, 2]) }.new(1, 2, 3)
  end

  expect 1 do
    Class.new{ Value(:a, [:b, 2], :'*c') }.new(1, 4, 2).instance_eval{ a }
  end

  expect 4 do
    Class.new{ Value(:a, [:b, 2], :'*c') }.new(1, 4, 2).instance_eval{ b }
  end

  expect [2] do
    Class.new{ Value(:a, [:b, 2], :'*c') }.new(1, 4, 2).instance_eval{ c }
  end

  expect true do
    c = Class.new{ Value(:a, :b, :c) }
    c.new(1, 2, 3) == c.new(1, 2, 3)
  end

  expect false do
    c = Class.new{ Value(:a, :b, :c) }
    c.new(1, 2, 3) == c.new(2, 3, 1)
  end

  expect true do
    c = Class.new{ Value(:a, :b, :c) }
    c.new(1, 2, 3).eql? c.new(1, 2, 3)
  end

  expect false do
    c = Class.new{ Value(:a, :b, :c) }
    c.new(1, 2, 3).eql? c.new(2, 3, 1)
  end

  expect true do
    c = Class.new{ Value(:a, :b, :c) }
    c.new(1, 2, 3).hash == c.new(1, 2, 3).hash
  end

  expect false do
    c = Class.new{ Value(:a, :b, :c) }
    c.new(1, 2, 3).hash == c.new(2, 3, 1).hash
  end

  expect false do
    c = Class.new{ Value(:a, :b, :c) }
    c.new(1, 2, 3).hash == [1, 2, 3].hash
  end

  expect(/\A#<Class:0x[[:xdigit:]]+>\.new\(1, 2, 3\)\z/) do
    Class.new{ Value(:a, :b, :c) }.new(1, 2, 3).inspect
  end
end
