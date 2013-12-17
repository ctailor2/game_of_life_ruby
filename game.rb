require_relative 'creature'

class Game
	attr_accessor :tick_count, :creatures

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
		set_neighbor_counts
		zap_select_creatures
		clean_up_creatures
	end

	def increment_counter
		self.tick_count += 1
	end

	def vacant_lots
		lots = []
		creatures.each do |creature|
			lots += creature.neighborhood
		end
		lots.reject! do |location|
			creature_locations(true).include?(location)
		end
		lots.uniq
	end

	def build_neighborhood(locations)
		locations.each do |location|
			creatures << Creature.new(*location)
		end
	end

	def creature_objects(alive)
		creatures.select{ |creature| creature.alive == alive }
	end

	def creature_locations(alive)
		creature_objects(alive).map{ |creature| creature.location }
	end

	def count_neighbors(creature)
		neighbor_locations = creature.neighborhood & creature_locations(true)
		neighbor_locations.length
	end

	def set_neighbor_counts
		creatures.each do |creature|
			creature.live_neighbors = count_neighbors(creature)
		end
	end

	def select_live_to_die
		rejects = []
		live_creatures = creature_objects(true)
		rejects += live_creatures.select{ |creature| creature.live_neighbors < 2 }
		rejects += live_creatures.select{ |creature| creature.live_neighbors > 3 }
		self.creatures -= rejects
		rejects
	end

	def select_dead_to_live
		rejects = []
		dead_creatures = creature_objects(false)
		rejects += dead_creatures.select{ |creature| creature.live_neighbors == 3 }
		self.creatures -= rejects
		rejects
	end

	def zap_select_creatures
		select_creatures = select_live_to_die + select_dead_to_live
		select_creatures.each do |creature|
			creature.zap!
		end
		self.creatures += select_creatures
	end

	def clean_up_creatures
		creatures.select!{ |creature| creature.alive }
	end
end
