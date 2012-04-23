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

  expect [:==, :b, :initialize] do
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

  expect [:==, :b, :initialize] do
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

  expect [:==, :b, :initialize] do
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

  expect "@param [A] other\n@return [Boolean] True if the receiver’s class, a, {#b}, and c block `#==` those of _other_" do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [String] a
  # @param [Integer] *b The b
  # @param [Proc] &c
  Value(:a, :'*b', :'&c')
end
EOS
    YARD::Registry.at('A#==').docstring.to_raw
  end

  expect "@param [A] other\n@return [Boolean] True if the receiver’s class and block `#==` those of _other_" do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A
  # @param [Proc] &block
  Value(:'&block')
end
EOS
    YARD::Registry.at('A#==').docstring.to_raw
  end
end
