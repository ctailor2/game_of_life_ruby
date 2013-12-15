class Game
	attr_reader :creatures, :tick_count

	def initialize(num_creatures)
		@creatures = []
		@tick_count = 0

		starting_locations(num_creatures).each do |location|
			@creatures << Creature.new(*location, true)
		end
	end

	def starting_locations(num_creatures)
		locations = []
		bound = starting_bound(num_creatures)
		until locations.uniq.length == num_creatures
			locations << [rand(bound), rand(bound)]
		end
		locations.uniq
	end

	def starting_bound(num_creatures)
		Math.sqrt(num_creatures * 5).floor.to_i
	end
end
