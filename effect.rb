class Effect
  attr_accessor :name, :source, :behavior
  
  def initialize(options)
    @name = options[:name]
    @source = options[:source]
    @behavior = options[:behavior]
  end
  
  def allow?(params)
    # Pass the params on to the lambda representing the behavior
    self.behavior.call(params)
  end
end
