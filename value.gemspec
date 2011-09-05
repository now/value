# -*- coding: utf-8 -*-

$:.unshift File.expand_path('../lib', __FILE__)

require 'value/version'

Gem::Specification.new do |s|
  s.name = 'value'
  s.version = Value::Version

  s.author = 'Nikolai Weibull'
  s.email = 'now@bitwi.se'
  s.homepage = 'http://github.com/now/value'

  s.description = IO.read(File.expand_path('../README', __FILE__))
  s.summary = s.description[/^  [[:alpha:]]+.*?\./]

  s.executables = Dir['bin/*'].map{ |path| File.basename(path) }
  s.files = Dir['{lib,test}/**/*.rb'] + %w[README Rakefile]

  s.add_development_dependency 'lookout', '~> 2.0'
  s.add_development_dependency 'rbtags', '~> 0.1.0'
  s.add_development_dependency 'yard', '~> 0.7.0'
end
