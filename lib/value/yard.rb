# -*- coding: utf-8 -*-

require 'yard'

class YARD::Handlers::Ruby::ValuesHandler < YARD::Handlers::Ruby::Base
  handles method_call('Value')
  namespace_only

  process do
    parameters = statement.parameters(false)
    if YARD::Parser::Ruby::AstNode === parameters[-1][0] and
        parameters[-1][0].type == :assoc and
        comparable = parameters[-1].find{ |e| e.jump(:ident).source == 'comparable' }
      parameters.pop
      comparables = (comparable[1].type == :array and comparable[1][0].map{ |e| e.jump(:ident).source })
      ancestor 'Comparable'
      ancestor 'Value::Comparable'
    end
    ancestor 'Value'
    initialize = define('initialize', parameters.map{ |e| [e.jump(:ident).source, e.type == :array ? e[0][1].source : nil] })
    initialize.docstring.tags(:param).select{ |e| e.text and not e.text.empty? }.each do |e|
        define e.name.sub(/\A[&*]/, ''), [],
               '@return [%s] %s' % [e.types.join(', '), e.text], :protected
        e.text = ''
      end
    initialize.docstring.add_tag(YARD::Tags::Tag.new(:note, 'Comparisons between instances are made between %s.' % join(comparables))) if comparables
  end

  def ancestor(name)
    modul = Proxy.new(:root, name).tap{ |m| m.type = :module }
    namespace.mixins(scope).unshift(modul) unless namespace.mixins(scope).include? modul
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

  def join(items)
    return items.join('') if items.size < 2
    return items.join(' and ') if items.size < 3
    return '%s, and %s' % [items[0..-2].join(', '), items[-1]]
  end
end

YARD::Handlers::Ruby::MacroHandler::IGNORE_METHODS['Value'] = true
