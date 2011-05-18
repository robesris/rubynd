require 'space'

class Board
	GRID_HEIGHT = 7
	GRID_WIDTH = 7

  def height
    GRID_HEIGHT
  end
  
  def width
    GRID_WIDTH
  end

	def initialize(num_players)
		@grid = Array.new(GRID_HEIGHT * GRID_WIDTH)
		GRID_HEIGHT.downto(1) do |row|
			1.upto(GRID_WIDTH) do |col|
				self[col, row] = Space.new(col, row)
			end
		end
		@keeps = Array.new(num_players)
	end

	def [](col, row)
		#externally access the board as a 1-indexed grid
		#translate letters to numbers if necessary
		if col.is_a? String
			col = l_to_n(col)
		else
			col -= 1
		end

		if row.is_a? String
			row = l_to_n(row)
		else
			row -= 1
		end

		@grid[(GRID_HEIGHT * (GRID_HEIGHT - 1 - row)) + col]
	end

	def []=(col, row, space)
		#externally access the board as a 1-indexed grid
		#translate letters to numbers if necessary
		if col.is_a? String
			col = l_to_n(col)
		else
			col -= 1
		end

		if row.is_a? String
			row = l_to_n(row)
		else
			row -= 1
		end

		@grid[(GRID_HEIGHT * (GRID_HEIGHT - 1 - row)) + col] = space
	end

	def grid
		@grid
	end

	private

	def l_to_n(letter)
		case letter.capitalize
		when (letter.is_a? Numeric) then letter.to_i
		when "A" then 0
		when "B" then 1
		when "C" then 2
		when "D" then 3
		when "E" then 4
		when "F" then 5
		when "G" then 6
		else nil
		end
	end

end
