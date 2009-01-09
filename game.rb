require 'player'
require 'board'
require 'piece'

class Game
	NUM_PLAYERS = 2

	def initialize
		@player0 = Player.new(0)
		@player1 = Player.new(1)
		@player0.opponent = @player1
		@player1.opponent = @player0
		@board = Board.new(NUM_PLAYERS)
		@pieces = []
		@state = :setup
		@active_player = @player1
	end

	def win(player)
		@state = player == @player0 ? :win_player0 : win_player1
	end

	def player(num)
		if num == 0
			@player0
		elsif num == 1
			@player1
		else
			nil
		end
	end

	def player0
		player(0)
	end

	def player1
		player(1)
	end

	def board
		@board
	end

	def state
		@state
	end

	def state=(newstate)
		@state = newstate
	end

end
