class Effect
  attr_accessor :source,      # The object that created and 'owns' this Effect
                :name         # The name of the effect
                :behavior     # The name of the method invoked when this Effect is triggered
  
  def initialize(options)
    @name = options[:name]
    @source = options[:source]
    @behavior = options[:behavior]
  end
  
  def respond_to_action(action)
    # Pass the params on to the source's method identified by :behavior
    self.source.send(:behavior, action)
  end 
end
