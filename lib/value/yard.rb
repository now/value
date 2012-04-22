# -*- coding: utf-8 -*-

require 'yard'

class YARD::Handlers::Ruby::ValuesHandler < YARD::Handlers::Ruby::Base
  handles method_call('Value')
  namespace_only

  process do
    modul = Proxy.new(:root, 'Value')
    modul.type = :module
    namespace.mixins(scope).unshift(modul) unless namespace.mixins(scope).include? modul
    parameters = statement.parameters(false).map{ |e| [e.jump(:ident).source, e.type == :array ? e[0][1].source : nil] }
    accessors = define('initialize', parameters).docstring.tags(:param).select{ |e| e.text and not e.text.empty? }.each do |e|
      define basename(e.name), [], '@return [%s] %s' % [e.types.join(', '), e.text], :protected
      e.text = ''
    end
    define '==', %w'other',
      ("@param [%s] other\n" +
       "@return [Boolean] True if the receiver’s class%s%s%s and %s `#==` those of _other_") %
        [namespace.name,
         parameters.size > 1 ? ', ' : '',
         parameters[0..-2].map{ |name, _| (accessors.any?{ |e| e.name == name } ? '{#%s}' : '%s') % basename(name) }.join(', '),
         parameters.size > 1 ? ',' : '',
         parameters.last.first.start_with?('&') ?
           '%s block' % parameters.last.first[1..-1] :
           basename(parameters.last.first)]
  end

  def define(name, parameters, docstring = nil, visibility = :public)
    YARD::CodeObjects::MethodObject.new(namespace, name).tap{ |m|
      register(m)
      m.dynamic = true
      m.signature = 'def %s%s' % [name,
                                  parameters.empty? ? '' :
                                  '(%s)' % parameters.map{ |n, d| d ? '%s = %s' % [n, d] : n }.join(', ')]
      m.parameters = parameters
      m.docstring = docstring if docstring
      m.visibility = visibility
      m
    }
  end

  def basename(name)
    name.sub(/\A[&*]/, '')
  end
end

YARD::Handlers::Ruby::MacroHandler::IGNORE_METHODS['Value'] = true
