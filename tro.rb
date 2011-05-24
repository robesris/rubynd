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

  def en_drop_behavior(action) #Add 10 to controlling player's pool when killed by opponent
    puts "GOT HERE!!!!"
    debugger
    # Assuming for now this reward only happens on an actual capture
    #if action[:action] == :die && @game.active_player == @player.opponent
    if action[:action] == :die && action[:player] == :opponent
      @player.pool_add(10)
    end
  end

	def flip
		if super
			@movement_grid = @@SIDE2
			@myeffect = Effect.new(:name => @flipname, :source => self, :behavior => :en_drop_behavior)
			@effects << @myeffect
		end
	end
	
	def flipback
	  if super
	    @effects -= @myeffect
	  end
	end 

end
