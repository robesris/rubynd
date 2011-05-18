require 'game.rb'

class Frontend

	def self.draw_board
		@@g.board.grid.each do |s|
			print "\n\n" if s.col == 1
			if s.piece != nil
				print s.piece.player.num == 0 ? "0 " : "1 "
			else
				print "_ "
			end
		end
		print "\n"
	end

	def self.tryit
		@@g = Game.new
		@@b = @@g.board
		draw_board
		@@p = BlackStone.new(@@g.player0, b[4,3])
		@@g.pieces += [@@p]
		draw_board
		puts p.move(b[4,4])
		draw_board
		puts p.move(b[7,7])
		draw_board
		puts p.move(b[4,5])
		draw_board
		puts "Player 1 pool: " + @@g.player0.pool.to_s
		puts "Player 2 pool: " + @@g.player1.pool.to_s
	end

	def self.g
		@@g
	end

	def self.b
		@@b
	end

	def self.p
		@@p
	end
end


