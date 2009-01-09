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
		@@p = Black_Stone.new(@@g.player0, b[4,3])
		@@g.pieces += [@@p]
		draw_board
		puts p.move(b[4,4])
		draw_board
		puts p.move(b[7,7])
		draw_board
		puts p.move(b[4,5])
		draw_board
		puts @@g.player0.pool
		puts @@g.player1.pool
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

