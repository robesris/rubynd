class Tro < Piece
	@@SIDE1 = DIAGONAL
	@@SIDE2 = [ 0, 0, 1, 0, 0,
							0, 1, 0, 1, 0,
							1, 0, 0, 0, 1,
							0, 1, 0, 1, 0,
							0, 0, 1, 0, 0 ]

	def initialize(player, space)
		super(player, space)
		@name = "Tro"
		@flipname = "En Drop"
		@num = 1
		@cost = 4

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
