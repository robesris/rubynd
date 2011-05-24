class Player
	KEEP_SIZE = 7
	MAX_POOL = 60

  attr_accessor :pieces, :graveyard

	def initialize(num)
		@num = num
		@graveyard = []
		@pool = 0
		@pieces = []
		@keep = []
	end

	def pool_add(amt)
		@pool += amt
		@pool = MAX_POOL if @pool > MAX_POOL
	end

	def pool_sub(amt)
		@pool -=amt
		@pool = 0 if @pool < 0
	end

	def num
		@num
	end

	def pool
		@pool
	end

	def pool=(num)
		@pool = num
	end

	def keep
		@keep
	end

	def opponent
		@opponent
	end

	def opponent=(player)
		@opponent = player
	end

end
