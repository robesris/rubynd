module Affectable
  def run_effects(action = {})
    # do we need these results?
    #results = []
    effects.each do |e|
      response = e.respond_to_action(action)
      return false if response == false
      #results << e.respond_to_action(action)
    end
    #results
    true
  end
end
