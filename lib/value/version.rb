# -*- coding: utf-8 -*-

require 'inventory-1.0'

module Value
  Version = Inventory.new(1, 1, 1){
    def dependencies
      super + Inventory::Dependencies.new{
        development 'inventory-rake', 1, 3, 0
        development 'lookout', 3, 0, 0
        development 'lookout-rake', 3, 0, 0
        development 'yard', 0, 7, 0
      }
    end

    def libs
      %w'
        value/comparable.rb
        value/values.rb
      '
    end
  }
end
