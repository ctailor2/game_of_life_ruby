class Creature
	attr_reader :location, :x, :y
	attr_accessor :live_neighbors, :alive

	def initialize(x, y, alive = false)
		@x = x
		@y = y
		@location = [x, y]
		@alive = alive
		@live_neighbors = 0
	end

	def neighborhood
		locations = []
		x_range = x - 1 .. x + 1
		y_range = y - 1 .. y + 1

		x_range.each do |x|
			y_range.each do |y|
				locations << [x, y]
			end
		end

		locations.delete(location)
		locations
	end
end