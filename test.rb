require 'game.rb'

require 'rubygems'
require 'ruby-debug/debugger'

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
		puts "Player 1 pool: " + @@g.player0.pool.to_s
		puts "Player 2 pool: " + @@g.player1.pool.to_s
	end

	def self.tryit
		@@g = Game.new
		@@b = @@g.board
		@@g.player1.pool = 25
		tro = Tro.new(@@g.player1, b[4,4])
		tro.flip
    # draw_board
    # @@p = BlackStone.new(@@g.player0, b[4,3])
    # @@g.pieces += [@@p]
    # draw_board
    # puts p.move(b[4,4])
    # draw_board
    # puts p.move(b[7,7])
    # draw_board
    # puts p.move(b[4,5])
		draw_board
		move(2,2,2,3)
		move 2,3,2,4
		move 2,4,2,5
		move 2,5,2,6
		
		move 4,2,4,3
		move 4,3,4,4  # capture Tro
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
	
	def self.move(c1,r1,c2,r2)
	  puts self.g.move(c1,r1,c2,r2)[:message]
	  self.draw_board
  end
end
