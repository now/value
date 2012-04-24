# -*- coding: utf-8 -*-

require 'inventory-1.0'

module Value
  Version = Inventory.new(1, 0, 0){
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
