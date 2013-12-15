class Creature
	attr_reader :alive, :location, :live_neighbors

	def initialize(x, y, alive = false)
		@location = [x, y]
		@alive = alive
		@live_neighbors = 0
	end
end