# Possible actions:
# attempt_enter
# entered_by

require 'affectable'

class Space
  attr_reader :attribs, :col, :row
  attr_accessor :effects, :piece
  
  include Affectable
  
	def initialize(col, row, attribs = {})
		@col = col
		@row = row
		@attribs = attribs
		@effects = []
		@piece = nil
	end

  def can_be_entered_by?(piece)
    # Test effects
    result = self.run_effects(:action => :attempt_enter, :source => piece)
    return false if result == false
    
    # If there's a piece here, see if the piece will allow us to move here
    return self.piece.can_be_captured_by?(piece) if self.piece
    
    # If there's no piece, we can move here
    true
  end
  
  def entered_by(piece)
    self.piece = piece
    
    self.run_effects(:action => :entered_by, :source => piece)
  end
  
  def exited_by(piece)
    self.piece = nil
  end
end
