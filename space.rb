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
      return false unless effect.allow?(:piece => piece, :action => :move)
    end
    true
  end  
end
