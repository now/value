# -*- coding: utf-8 -*-

Expectations do
  expect RuntimeError.new(/\Ano values have been set for class: /) do
    Class.new(Value).values
  end

  expect [:a, :b, :c] do
    Class.new(Value).values(:a, :b, :c)
  end

  expect [:a, :b, :c] do
    Class.new(Value).tap{ |c| c.values :a, :b }.values(:c)
  end

  expect ArgumentError.new('wrong number of arguments (0 for 1)') do
    Class.new(Value).tap{ |c| c.values :a }.new
  end

  expect ArgumentError.new('wrong number of arguments (2 for 1)') do
    Class.new(Value).tap{ |c| c.values :a }.new(1, 2)
  end

  expect Class.new(Value) do |c|
    c.tap{ |c| c.values :a }.new(1)
  end

  expect true do
    Class.new(Value).tap{ |c| c.values :a }.new(1).frozen?
  end

  expect NoMethodError do
    Class.new(Value).tap{ |c| c.values :a }.new(1).a
  end

  expect 1 do
    Class.new(Value).tap{ |c| c.values :a }.new(1).instance_eval{ a }
  end

  expect 1 do
    Class.new(Value).tap{ |c| c.values :a }.new(1).instance_variable_get(:@a)
  end

  expect true do
    c = Class.new(Value).tap{ |c| c.values :a, :b, :c }
    c.new(1, 2, 3) == c.new(1, 2, 3)
  end

  expect false do
    c = Class.new(Value).tap{ |c| c.values :a, :b, :c }
    c.new(1, 2, 3) == c.new(2, 3, 1)
  end

  expect true do
    c = Class.new(Value).tap{ |c| c.values :a, :b, :c }
    c.new(1, 2, 3).eql? c.new(1, 2, 3)
  end

  expect false do
    c = Class.new(Value).tap{ |c| c.values :a, :b, :c }
    c.new(1, 2, 3).eql? c.new(2, 3, 1)
  end

  expect true do
    c = Class.new(Value).tap{ |c| c.values :a, :b, :c }
    c.new(1, 2, 3).hash == c.new(1, 2, 3).hash
  end

  expect false do
    c = Class.new(Value).tap{ |c| c.values :a, :b, :c }
    c.new(1, 2, 3).hash == c.new(2, 3, 1).hash
  end

  expect false do
    c = Class.new(Value).tap{ |c| c.values :a, :b, :c }
    c.new(1, 2, 3).hash == [1, 2, 3].hash
  end

  expect(/\A#<Class:0x[[:xdigit:]]+>\.new\(1, 2, 3\)\z/) do
    Class.new(Value).tap{ |c| c.values :a, :b, :c }.new(1, 2, 3).inspect
  end
end
