require 'search_dimensions'

module NTEE
  class SearchDimension < SearchDimensions::HierarchicalDimension
    def value_class
      NTEE::DimensionValue
    end
  end
  
  class DimensionValue < SearchDimensions::HierarchicalValue
    def category
      NTEE.category(leaf_value)
    end
  
    def label
      category ? category.name : super
    end
    
    def param_value
      category ? category.code : super
    end
    
    def facet_children(search)
      super.sort_by(&:label)
    end
  end
end