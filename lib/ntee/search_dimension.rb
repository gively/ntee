require 'search_dimensions'

module NTEE
  class HierarchicalDimension < SearchDimensions::HierarchicalDimension
    def value_class
      NTEE::HierarchicalDimensionValue
    end
  end
  
  class HierarchicalDimensionValue < SearchDimensions::HierarchicalValue
    def category
      NTEE.category(leaf_value)
    end
    
    def value=(new_value)
      category = NTEE.category(new_value)
      
      if category
        # we got an NTEE code as our value, let's convert it to a hierarchical path
        self.value = values_for_category(category)
      else
        super
      end
    end
    
    def values_for_category(category)
      values_for_path(category.ancestors.reverse + [category]).map(&:code))
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
  
  class FlatDimension < SearchDimensions::Dimension
    def value_class
      NTEE::FlatDimensionValue
    end
  end
  
  class FlatDimensionValue < SearchDimensions::DimensionValue
    def category
      NTEE.category(value)
    end
    
    def label
      category ? category.name : super
    end
    
    def param_value
      category ? category.code : super
    end
  end
end