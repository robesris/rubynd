require 'effect'

class Piece
	 
  attr_accessor :effects, :myeffect, :space, :attribs
  attr_reader :player, :name, :num, :game, :movement_grid, :cost
  
	MOVEMENT_GRID_WIDTH = 5
	MOVEMENT_GRID_HEIGHT = 5
	MAX_COL_MOVE = (MOVEMENT_GRID_WIDTH - 1) / 2 # => 2
	MAX_ROW_MOVE = (MOVEMENT_GRID_HEIGHT - 1) / 2 # => 2
	MOVEMENT_GRID_CENTER = MOVEMENT_GRID_WIDTH * MAX_ROW_MOVE + MAX_COL_MOVE # => 12

	@@SIDE1 = nil
	@@SIDE2 = nil

	def initialize(player, space, owner = player)
		@owner = owner
		@player = player
		player.pieces << self
		@space = space
		space.piece = self
		@effects = {}
		@attribs = {}
		@game = game
	end

  def run_effects(trigger)
    effects.each do |e|
      e.behavior.call(trigger)
    end
  end

	def pay_for_flip
		if attribs[:flipped] || attribs[:unflippable] || @player.pool < @cost
			nil
		elsif run_effects(:try_flip)
			@player.pool -= @cost
		end
	end

	def flip
		if pay_for_flip
			@movement_grid = @@SIDE2
			attribs[:flipped] = true
		end
	end

	def flipback
		if attribs[:flipped] && !attribs[:unflippable]
			@movement_grid = @@SIDE1
			attribs[:flipped] = false
		end
	end

	def die
		@space.piece = nil
		@player.graveyard << self
		run_effects(:die)
	end

	#def space=(new_space)
	#	@space = new_space
	#end

=begin
	def attribs
		@attribs
	end

	def attribs=(attrib)
		@attribs = attrib
	end
=end

	# = move(move_to)
	#
	# Handles piece movement.
	# move_to: a Space object representing the space the piece is attempting to move to
	#
	def move(move_to)
		#This is going to be the most complex method in the game

		#Flip the movement grid around for player1 (i.e. second player)
		mg = @player.num == 0 ? @movement_grid : @movement_grid.reverse



		#calculate the number of columns and rows the space is from current position
		col_move = move_to.col - @space.col # Left: <0  Right: >0
		row_move = move_to.row - @space.row # Up: >0  Down: <0

    #check if the piece's movement grid allows it to move DIRECTLY (i.e. 'jump') to the specified space 
		if col_move.abs <= MAX_COL_MOVE &&
			 row_move.abs <= MAX_ROW_MOVE &&
			 mg[MOVEMENT_GRID_CENTER - (MOVEMENT_GRID_WIDTH * row_move) + col_move] != 0
			####### HANDLE BASIC MOVEMENT (i.e. movement to yellow squares) ############

			yield move_to if block_given?	 # piece-specific stuff that happens during movement

			# default movement
			if move_to.piece == nil
				simple_move(move_to)
			elsif move_to.piece.player = @player
				nil
			else
				#TRY TO CAPTURE AN OPPONENT'S PIECE
				true
			end

		else #if the piece can't jump to the specified space, see if it can 'slide' there
			#HANDLE ADVANCED MOVEMENT
			nil
		end

	end

	private

	def simple_move(move_to)
		@space.piece = nil
		@space = move_to
		@space.piece = self
	end
	
	#Some common movement grids
	KING							= [ 0, 0, 0, 0, 0,
												0, 1, 1, 1, 0,
												0, 1, 0, 1, 0,
												0, 1, 1, 1, 0,
												0, 0, 0, 0, 0 ]

	GOLD							= [ 0, 0, 0, 0, 0,
												0, 1, 1, 1, 0,
												0, 1, 0, 1, 0,
												0, 0, 1, 0, 0,
												0, 0, 0, 0, 0 ]

	SILVER 						= [ 0, 0, 0, 0, 0,
												0, 1, 1, 1, 0,
												0, 0, 0, 0, 0,
												0, 1, 0, 1, 0,
												0, 0, 0, 0, 0 ]

	BLACK							= [ 0, 0, 0, 0, 0,
												0, 0, 1, 0, 0,
												0, 0, 0, 0, 0,
												0, 0, 0, 0, 0,
												0, 0, 0, 0, 0 ]

	RED								= [ 0, 0, 0, 0, 0,
												0, 1, 1, 1, 0,
												0, 0, 0, 0, 0,
												0, 0, 0, 0, 0,
												0, 0, 0, 0, 0 ]

	ROOKLIKE					= [ 0, 0, 1, 0, 0,
												0, 0, 1, 0, 0,
												1, 1, 0, 1, 1,
												0, 0, 1, 0, 0,
												0, 0, 1, 0, 0 ]

	BISHOPLIKE				= [ 1, 0, 0, 0, 1,
												0, 1, 0, 1, 0,
												0, 0, 0, 0, 0,
												0, 1, 0, 1, 0,
												1, 0, 0, 0, 1 ]

	SQUARE						= [ 0, 0, 0, 0, 0,
												0, 0, 1, 0, 0,
												0, 1, 0, 1, 0,
												0, 0, 1, 0, 0,
												0, 0, 0, 0, 0 ]

	DIAGONAL					= [ 0, 0, 0, 0, 0,
												0, 1, 0, 1, 0,
												0, 0, 0, 0, 0,
												0, 1, 0, 1, 0,
												0, 0, 0, 0, 0 ]
end

# -------------
# = Black_Stone
# -------------
class Black_Stone < Piece

	def initialize(player, space)
		super(player, space)
		@name = "Black Stone"
		@num = -1
		@cost = 1
		@movement_grid = BLACK
		@attribs[:unflippable] = true
	end

	def move(move_to)
		if super(move_to) && @player.pool < Player::MAX_POOL
			@player.pool += 1
		end
	end

	def flip
		nil
	end
end

# ------------
# = Red_Stone
# ------------
class Red_Stone < Piece

	def initialize(player, space)
		super(player, space)
		@name = "Red Stone"
		@num = -2
		@cost = 3
		@movement_grid = RED
		@attribs[:unflippable] = true
	end

	def move(move_to)
		if super(move_to) && @player.pool < Player::MAX_POOL
			@player.pool += 3
		end
	end

	def flip
		nil
	end
end

# ------------
# = Nav
# ------------
class Nav < Piece

	def initialize(player, space)
		super(player, space)
		@cost = 60
		@movement_grid = KING
		@attribs[:nav] = true
	end

	def flip
		:win
	end

end

# ------------
# = Nav_Est
# ------------
class Nav_Est < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Est"
		@num = 1
	end

end

# ------------
# = Nav_Deb
# ------------
class Nav_Deb < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Deb"
		@num = 2
	end

end

# ------------
# = Nav_I
# ------------
class Nav_I < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav I"
		@num = 3
	end

end

# ------------
# = Nav_Kr
# ------------
class Nav_Kr < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Kr"
		@num = 4
	end

end

# ------------
# = Nav_Cha
# ------------
class Nav_Cha < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Cha"
		@num = 5
	end

end

# ------------
# = Nav_Hil
# ------------
class Nav_Hil < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Hil"
		@num = 6
	end

end

# ------------
# = Nav_Per
# ------------
class Nav_Per < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Per"
		@num = 7
	end

end

require 'tro'
require 'ham'
