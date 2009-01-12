class Effect
  attr_accessor :name, :source, :behavior
  
  def initialize(options)
    @name = options[:name]
    @source = options[:source]
    @behavior = options[:behavior]
  end
end
