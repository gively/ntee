require 'ntee/version'

module NTEE
  class Category
    attr_accessor :name, :code, :subcategories, :parent
    
    def initialize
      self.subcategories ||= {}
    end
    
    def inspect
      "<NTEE Category #{code} (#{name})>"
    end
    
    def [](subcategory_code)
      self.subcategories[subcategory_code.to_s]
    end
    
    def parent=(parent)
      if parent && parent.subcategories[code] != self
        parent.add_subcategory!(self) 
      end
      
      @parent = parent
    end
    
    def add_subcategory!(subcategory)
      subcategories[subcategory.code.to_s] = subcategory
      subcategory.parent = self
      subcategories
    end
  end
  
  class << self
    attr_accessor :root_categories, :all_categories
      
    def category(code)
      all_categories[code.to_s]
    end
    
    def add_category!(category)
      root_categories[category.code.to_s] = category if category.parent.nil?
      category.subcategories.each do |code, subcategory|
        add_category!(subcategory)
      end
      all_categories[category.code.to_s] = category
    end
  end
  
  self.root_categories = {}
  self.all_categories = {}
  
  begin
    require 'yaml'
    
    File.open(File.expand_path("../ntee_categories.yml", __FILE__), 'r') do |file|
      YAML.load(file).each do |code, category|
        add_category!(category)
      end
    end
  rescue
    puts "WARNING: Couldn't load NTEE categories!"
    puts $!
  end
end
