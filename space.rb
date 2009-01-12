class Space

	def initialize(col, row, attribs = {})
		@col = col
		@row = row
		@attribs = attribs
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

end
