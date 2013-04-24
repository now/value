# -*- coding: utf-8 -*-

require 'inventory-rake-1.0'

load File.expand_path('../lib/value-1.0/version.rb', __FILE__)

Inventory::Rake::Tasks.define Value::Version, :gem => proc{ |_, s|
  s.author = 'Nikolai Weibull'
  s.email = 'now@bitwi.se'
  s.homepage = 'https://github.com/now/value'
}

Inventory::Rake::Tasks.unless_installing_dependencies do
  require 'lookout-rake-3.0'
  Lookout::Rake::Tasks::Test.new

  require 'inventory-rake-tasks-yard-1.0'
  Inventory::Rake::Tasks::YARD.new do |t|
    t.options += %w'--plugin yard-heuristics-1.0'
    t.globals[:source_code_url] = 'https://github.com/now/%s/blob/v%s/%%s#L%%d' % [t.inventory.package, t.inventory]
  end
end
