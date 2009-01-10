class Ham < Piece
	@@SIDE1 = DIAGONAL
	@@SIDE2 = [ 0, 0, 0, 0, 0,
							0, :ul, 1, :ur, 0,
							0, 1, 0, 1, 0,
							0, :dl, 1, :dr, 0,
							0, 0, 0, 0, 0 ]

	def initialize(player, space)
		super(player, space)
		@name = "Ham"
		@flipname = nil
		@num = 3
		@cost = 9

		@movement_grid = @@SIDE1
	end

	def flip
		if super
			@movement_grid = @@SIDE2
		end
	end

	def die
		super
		@player.pool_add(10) if game.active_player == @player.opponent
	end
end