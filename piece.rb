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

  def run_effects(action)
    # Do I need these results?  Or should the respond_to_action method be sufficient?
    results = []
    effects.each do |e|
      results << e.respond_to_action(action)
    end
    results
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

	# Move this piece to the graveyard and trigger any effects that happen when the piece is captured
	def die(params = {:source => self})
	  self.space = nil
	  self.space.piece = nil
	  self.flipback
		self.player.graveyard << self
		run_effects(:name => :die, :source => params[:source])
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

  # = can_reach?(space)
  #
  # Does the piece's movement grid allow it to move to the Space?
  def can_reach?(space)
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
			
      #yield move_to if block_given?	 # piece-specific stuff that happens during movement
			# manage this with effects instead ^^^
		else #if the piece can't jump to the specified space, see if it can 'slide' there
			#HANDLE ADVANCED MOVEMENT
			
			# The piece's grid doesn't allow it to move there
			false
		end
	end
	
	def can_enter?(space)
	  space.can_by_entered_by?(self)
  end
  
  def can_capture?(piece)
    piece.can_be_captured_by?(self)
  end
  
  def can_be_captured_by?(piece)
    # Test effects
    self.effects.each do |effect|
      return false unless effect.respond_to_action(:piece => piece, :action => :capture)
    end
    
    # This piece can be captured
    true
  end
  
  def capture(opponent_piece)    
    opponent_piece.die(:source => self)
    run_effects(:name => :successful_capture)
			
	# = move(move_to)
	#
	# Handles piece movement.
	# move_to: a Space object representing the space the piece is attempting to move to
	#
	def move(move_to)
	  return false unless self.can_reach?(move_to) &&
	                      self.can_enter?(move_to)
	  
	  # We are able to move (and capture)
	  self.capture(move_to.piece) if move_to.piece
	  # check for win here?
	  self.enter(move_to)
	  
    #simple_move(move_to)

			# default movement
      # if move_to.piece == nil
      #   simple_move(move_to)
      # elsif move_to.piece.player == @player
      #   nil
      # else
      #   #TRY TO CAPTURE AN OPPONENT'S PIECE
      #   #IF MOVE IS SUCCESSFUL, TRY TO CAPTURE
      #   #IF CAPTURE IS SUCCESSFUL, THE OPPONENT'S PIECE SHOULD BE SENT :die
      #   nil
      # end

		

	end

	private

	def simple_move(move_to)
	  # Need to have Space run through effects for Space and Occupying piece, if applicable
		self.space.piece = nil
		self.space = move_to
		self.space.piece = self
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
# = BlackStone
# -------------
class BlackStone < Piece

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
# = RedStone
# ------------
class RedStone < Piece

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
# = NavEst
# ------------
class NavEst < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Est"
		@num = 1
	end

end

# ------------
# = NavDeb
# ------------
class NavDeb < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Deb"
		@num = 2
	end

end

# ------------
# = NavI
# ------------
class NavI < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav I"
		@num = 3
	end

end

# ------------
# = NavKr
# ------------
class NavKr < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Kr"
		@num = 4
	end

end

# ------------
# = NavCha
# ------------
class NavCha < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Cha"
		@num = 5
	end

end

# ------------
# = NavHil
# ------------
class NavHil < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Hil"
		@num = 6
	end

end

# ------------
# = NavPer
# ------------
class NavPer < Nav

	def initialize(player, space)
		super(player, space)
		@name = "Nav Per"
		@num = 7
	end

end

require 'tro'
require 'ham'
