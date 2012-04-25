# -*- coding: utf-8 -*-

require 'inventory-1.0'

module Value
  Version = Inventory.new(1, 0, 1){
    def dependencies
      super + Inventory::Dependencies.new{
        development 'lookout', 3, 0, 0
        development 'yard', 0, 7, 0
      }
    end

    def libs
      %w'
        value/comparable.rb
        value/values.rb
      '
    end

    def additional_libs
      super +
        %w'
          value/yard-1.0.rb
        '
    end
  }
end
