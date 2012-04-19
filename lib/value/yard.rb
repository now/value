# -*- coding: utf-8 -*-

require 'yard'

class YARD::Handlers::Ruby::ValuesHandler < YARD::Handlers::Ruby::Base
  handles method_call(:values)
  namespace_only

  def process
    names = statement.parameters(false).map{ |e| e.jump(:ident).source }
    define('initialize', names).docstring.tags(:param).select{ |e| e.text and not e.text.empty? }.each do |e|
      define e.name, [], '@return [%s] %s' % [e.types.join(', '), e.text], :protected
      e.text = ''
    end
    define '==', %w'other',
    ("@param [%s] other\n" +
     "@return [Boolean] True if the receiver’s class%s%s%s and %s `#==` those of _other_") %
      [namespace.name,
       names.size > 1 ? ', ' : '', names[0..-2].join(', '), names.size > 1 ? ',' : '', names.last]
  end

  def define(name, parameters, docstring = nil, visibility = :public)
    YARD::CodeObjects::MethodObject.new(namespace, name).tap{ |m|
      register(m)
      m.dynamic = true
      m.signature = '%s%s' % [name, parameters.empty? ? '' : '(%s)' % parameters.join(', ')]
      m.parameters = parameters.map{ |e| [e, nil] }
      m.docstring = docstring if docstring
      m.visibility = visibility
      m
    }
  end
end

YARD::Handlers::Ruby::MacroHandler::IGNORE_METHODS['values'] = true
