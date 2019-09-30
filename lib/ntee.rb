require 'ntee/version'

module NTEE
  class Category
    attr_accessor :code, :subcategories, :parent
    attr_writer :name

    def initialize
      self.subcategories ||= {}
    end

    def name
      # strip non-ascii characters
      @name.gsub(/[\u0080-\u00ff]/, "")
    end

    def to_s
      "#{name} (#{code})"
    end

    def inspect
      "<NTEE Category #{code} (#{name})>"
    end

    def [](subcategory_code)
      self.subcategories[subcategory_code.to_s]
    end

    def parent=(parent)
      if parent && parent[code] != self
        parent.add_subcategory!(self)
      end

      @parent = parent
    end

    def ancestors
      if parent
        [parent] + parent.ancestors
      else
        []
      end
    end

    def descendants
      (subcategories.values + subcategories.values.map(&:descendants)).flatten
    end

    def add_subcategory!(subcategory)
      subcategories[subcategory.code.to_s] = subcategory
      subcategory.parent = self
      subcategories
    end

    def as_json(options={})
      hsh = {
        'code' => code,
        'name' => name
      }

      hsh['subcategories'] = subcategories.values.as_json(options) if subcategories && subcategories.count > 0

      hsh
    end

    def attributes=(attributes)
      attributes.each do |name, value|
        case name.to_s
        when "code"
          self.code = value
        when "name"
          self.name = value
        when "parent"
          self.parent = value
        when "subcategories"
          subcats = value.collect do |subcat|
            case subcat
            when Category
              subcat
            when Hash
              Category.new.tap { |cat| cat.attributes = subcat }
            else
              raise "Subcategory #{value.inspect} is neither a Category nor a Hash"
            end
          end

          subcats.each do |subcat|
            add_subcategory!(subcat)
          end
        end
      end
    end
  end

  class << self
    attr_accessor :root_categories, :all_categories

    def category(cat_or_code)
      case cat_or_code
      when NTEE::Category
        cat_or_code
      else
        all_categories[cat_or_code.to_s]
      end
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

  def self.as_list
    @as_list ||= sort_by_code(flattened_categories)
  end

  private

  def self.flattened_categories
    all_categories.map do |parent_category|
      c = parent_category[1]
      [c.to_s, c.code]
    end
  end

  def self.sort_by_code(arr)
    arr.sort {|a, b| a[1] <=> b[1] }
  end
end

begin
  require 'json'

  File.open(File.expand_path("../ntee_categories.json", __FILE__), 'r') do |file|
    JSON.load(file).each do |attributes|
      NTEE::Category.new.tap do |category|
        category.attributes = attributes
        NTEE.add_category!(category)
      end
    end
  end
rescue
  puts "WARNING: Couldn't load NTEE categories!"
  puts $!
end
