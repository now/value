# -*- coding: utf-8 -*-

require 'yard'

class YARD::Handlers::Ruby::ValuesHandler < YARD::Handlers::Ruby::Base
  handles method_call('Value')
  namespace_only

  process do
    modul = Proxy.new(:root, 'Value').tap{ |m| m.type = :module }
    namespace.mixins(scope).unshift(modul) unless namespace.mixins(scope).include? modul
    define('initialize',
           statement.parameters(false).
             map{ |e| [e.jump(:ident).source, e.type == :array ? e[0][1].source : nil] }).
      docstring.tags(:param).select{ |e| e.text and not e.text.empty? }.each do |e|
        define e.name.sub(/\A[&*]/, ''), [],
               '@return [%s] %s' % [e.types.join(', '), e.text], :protected
        e.text = ''
      end
  end

  def define(name, parameters, docstring = nil, visibility = :public)
    YARD::CodeObjects::MethodObject.new(namespace, name).tap{ |m|
      register(m)
      m.signature = 'def %s%s' %
        [name,
         parameters.empty? ?
           '' :
           '(%s)' % parameters.map{ |n, d| d ? '%s = %s' % [n, d] : n }.join(', ')]
      m.parameters = parameters
      m.docstring = docstring if docstring
      m.visibility = visibility
    }
  end
end

YARD::Handlers::Ruby::MacroHandler::IGNORE_METHODS['Value'] = true
