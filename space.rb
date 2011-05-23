class Space
  attr_accessor :effects
  
	def initialize(col, row, attribs = {})
		@col = col
		@row = row
		@attribs = attribs
		@effects = []
		@piece = nil
	end

	def piece
		@piece
	end

	def piece=(new_piece)
		@piece = new_piece
	end

	def attribs
		@attribs
	end

	def col
		@col
	end

	def row
		@row
	end

  def can_be_entered_by?(piece)
    # Test effects
    self.effects.each do |effect|
      return false unless effect.respond_to_action(:piece => piece, :action => :move)
    end
    
    # If there's a piece here, see if the piece will allow us to move here
    return self.piece.can_be_captured_by?(piece) if self.piece
    
    # If there's no piece, we can move here
    true
  end  
end
