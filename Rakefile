# -*- coding: utf-8 -*-

require 'inventory/rake/tasks-1.0'
require 'lookout/rake/tasks-3.0'

$:.unshift File.expand_path('../lib', __FILE__)
require 'value/version'

Inventory::Rake::Tasks.define Value::Version, :gem => proc{ |_, s|
  s.author = 'Nikolai Weibull'
  s.email = 'now@bitwi.se'
  s.homepage = 'https://github.com/now/value'
}

# TODO: Silence warnings generated from YARD (remove this once we plug them)
Lookout::Rake::Tasks::Test.new :options => []
