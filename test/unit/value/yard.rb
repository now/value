# -*- coding: utf-8 -*-

require 'value/yard'

Expectations do
  expect [YARD::CodeObjects::Proxy.new(:root, 'Value')] do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [String] a
  # @param [Integer] b The b
  Value(:a, :b)
end
EOS
    YARD::Registry.at('A').mixins(:instance)
  end

  expect 'Represents As.' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # Represents As.
  Value(:a, :b)
end
EOS
    YARD::Registry.at('A#initialize').docstring
  end

  expect [['a', nil], ['b', '3']] do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  Value(:a, [:b, 3])
end
EOS
    YARD::Registry.at('A#initialize').parameters
  end

  expect [:b, :initialize] do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [String] a
  # @param [Integer] b The b
  Value(:a, :b)
end
EOS
    YARD::Registry.all(:method).map(&:name).sort
  end

  expect [:b, :initialize] do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [String] a
  # @param [Integer] *b The b
  Value(:a, :'*b')
end
EOS
    YARD::Registry.all(:method).map(&:name).sort
  end

  expect [:b, :initialize] do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [String] a
  # @param [Integer] &b The b
  Value(:a, :'&b')
end
EOS
    YARD::Registry.all(:method).map(&:name).sort
  end

  expect nil do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [String] a
  # @param [Integer] b The b
  Value(:a, :b)
end
EOS
    YARD::Registry.at('A#a')
  end

  expect '@return [Integer] The b' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [String] a
  # @param [Integer] b The b
  Value(:a, :b)
end
EOS
    YARD::Registry.at('A#b').docstring.to_raw
  end

  expect %w'Value Value::Comparable Comparable' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [String] a
  Value(:a, :comparable => true)
end
EOS
  YARD::Registry.at('A').inheritance_tree(true)[1..3].map(&:path)
  end

  expect %w'Value Value::Comparable Comparable' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
module A
  # @param [String] a
  Value(:a, :comparable => true)
end
class B
  include A
  # @param [String] a
  # @param [String] b
  Value(:a, :b, :comparable => true)
end
EOS
  YARD::Registry.at('B').inheritance_tree(true)[1..3].map(&:path)
  end
end
