# -*- coding: utf-8 -*-

require 'inventory'

module Value
  Version = Inventory.new(0, 2, 0){
    def additional_libs
      super +
        %w'
          value/yard.rb
        '
    end
  }
end
