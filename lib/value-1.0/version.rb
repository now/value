# -*- coding: utf-8 -*-

require 'inventory-1.0'

module Value
  Version = Inventory.new(1, 1, 2){
    def dependencies
      super + Inventory::Dependencies.new{
        development 'inventory-rake', 1, 4, 0
        development 'inventory-rake-tasks-yard', 1, 3, 0
        development 'lookout', 3, 0, 0
        development 'lookout-rake', 3, 0, 0
        development 'yard', 0, 8, 0
        development 'yard-heuristics', 1, 1, 0
      }
    end

    def package_libs
      %w[attributes.rb
         comparable.rb]
    end
  }
end
