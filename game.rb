require 'player'
require 'board'
require 'piece'

class Game
	NUM_PLAYERS = 2
	
	attr_accessor :pieces, :board, :state

	def initialize
		@player0 = Player.new(0)
		@player1 = Player.new(1)
		@player0.opponent = @player1
		@player1.opponent = @player0
		@board = Board.new(NUM_PLAYERS)
		@pieces = []
		@state = :setup
		@active_player = self.player0
		
    # Place stones on the board in starting positions
    1.upto(self.board.width) do |col|
      BlackStone.new(self.player0, self.board[col, 2])
      BlackStone.new(self.player1, self.board[col, 6])
    end
    
    RedStone.new(self.player0, self.board[2, 1])
    RedStone.new(self.player0, self.board[6, 1])
    RedStone.new(self.player1, self.board[2, 7])
    RedStone.new(self.player1, self.board[6, 7])
	end

	def win(player)
		@state = player == @player0 ? :win_player0 : :win_player1
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
end
