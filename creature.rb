class Creature
	attr_reader :alive, :location

	def initialize(x, y, alive = false)
		@location = [x, y]
		@alive = alive
	end
end