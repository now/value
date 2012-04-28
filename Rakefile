# -*- coding: utf-8 -*-

require 'inventory/rake-1.0'

load File.expand_path('../lib/value/version.rb', __FILE__)

Inventory::Rake::Tasks.define Value::Version, :gem => proc{ |_, s|
  s.author = 'Nikolai Weibull'
  s.email = 'now@bitwi.se'
  s.homepage = 'https://github.com/now/value'
}

Inventory::Rake::Tasks.unless_installing_dependencies do
  require 'lookout/rake-3.0'
  Lookout::Rake::Tasks::Test.new
end
