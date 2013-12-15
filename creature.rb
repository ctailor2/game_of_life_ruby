class Creature
	attr_reader :alive

	def initialize(x, y, alive = false)
		@alive = alive
	end
end