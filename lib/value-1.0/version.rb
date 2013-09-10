# -*- coding: utf-8 -*-

require 'inventory-1.0'

module Value
  Version = Inventory.new(1, 1, 3){
    authors{
      author 'Nikolai Weibull', 'now@disu.se'
    }

    homepage 'http://disu.se/software/value-1.0/'

    licenses{
      license 'LGPLv3+',
              'GNU Lesser General Public License, version 3 or later',
              'http://www.gnu.org/licenses/'
    }

    def dependencies
      super + Inventory::Dependencies.new{
        development 'inventory-rake', 1, 6, 0
        development 'inventory-rake-tasks-yard', 1, 4, 0
        development 'lookout', 3, 0, 0
        development 'lookout-rake', 3, 1, 0
        development 'yard', 0, 8, 0
        development 'yard-heuristics', 1, 2, 0
      }
    end

    def package_libs
      %w[attributes.rb
         comparable.rb]
    end
  }
end
