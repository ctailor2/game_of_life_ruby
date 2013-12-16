class Game
	attr_reader :creatures
	attr_accessor :tick_count

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

	def tick
		increment_counter
		build_neighborhood(vacant_lots)
	end

	def increment_counter
		self.tick_count += 1
	end

	def vacant_lots
		lots = []
		creatures.each do |creature|
			lots += creature.neighborhood
		end
		lots.reject do |location|
			creature_locations(true).include?(location)
		end
		lots
	end

	def build_neighborhood(locations)
		locations.each do |location|
			creatures << Creature.new(*location)
		end
	end

	def creature_locations(alive)
		creatures.select{ |creature| creature.alive == alive }.map{ |creature| creature.location }
	end
end
