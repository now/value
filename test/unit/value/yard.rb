# -*- coding: utf-8 -*-

require 'value/yard'

Expectations do
  expect 'Represents As.' do
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A < Value
  # Represents As.
  values :a, :b
end
EOS
    YARD::Registry.at('A#initialize').docstring
  end

  expect nil do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A < Value
  # Represents As.
  # @param [String] a
  # @param [Integer] b The b
  values :a, :b
end
EOS
    YARD::Registry.at('A#a')
  end

  expect '@return [Integer] The b' do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A < Value
  # Represents As.
  # @param [String] a
  # @param [Integer] b The b
  values :a, :b
end
EOS
    YARD::Registry.at('A#b').docstring.to_raw
  end

  expect "@param [A] other\n@return [Boolean] True if the receiver’s class, a, and b `#==` those of _other_" do
    YARD::Registry.clear
    YARD::Parser::SourceParser.parse_string(<<EOS)
class A < Value
  # Represents As.
  # @param [String] a
  # @param [Integer] b The b
  values :a, :b
end
EOS
    YARD::Registry.at('A#==').docstring.to_raw
  end
end
