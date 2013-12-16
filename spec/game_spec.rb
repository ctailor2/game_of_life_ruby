require_relative '../game'

describe Game do
	let(:game) { Game.new(5) }	

	describe "#creatures" do

		it "is a collection" do
			expect(game.creatures).to be_a(Array)
		end

		it "contains Creature objects" do
			expect(game.creatures.all? {|creature| creature.class == Creature}).to be_true
		end

		it "contains the correct number of Creature objects" do
			expect(game.creatures.length).to eq(5)
		end
	end

	describe "#starting_locations" do

		it "returns the correct number of locations" do
			expect(game.starting_locations(10).length).to eq(10)
		end

		it "returns a set of unique locations" do
			expect(game.starting_locations(10).uniq.length).to eq(10)
		end
	end

	describe "#starting_bound" do
		it "ensures creatures take up at least 20% of their starting area" do
			num_creatures = game.creatures.length
			expect(num_creatures.to_f / (game.starting_bound(5) ** 2)).to be >= 0.20
		end
	end

	describe "#tick_count" do
		it "starts at 0" do
			expect(game.tick_count).to eq(0)
		end
	end

	describe "#tick" do

		context "with 1 live creature" do
			it "populates vacancies with dead creatures" do
				game.creatures.clear
				creature = Creature.new(1, 1, true)
				game.creatures << creature
				game.tick
				game.creatures.delete(creature)
				expect(game.creatures.all?{ |creature| creature.alive == false }).to be_true
			end
		end
	end

	describe "#vacant_lots" do
		let(:creature_a) { Creature.new(1, 1, true) }
		let(:creature_b) { Creature.new(2, 1, true) }
		let(:creature_c) { Creature.new(2, 2, true) }

		context "with 1 live creature" do
			it "returns the correct set of locations" do
				game.creatures.clear
				game.creatures << creature_a
				expect(game.vacant_lots).to include([0, 0], [1, 0], [2, 0], [0, 1], [2, 1], [0, 2], [1, 2], [2, 2])
			end
		end

		context "with 2 adjacent live creatures" do
			it "populates the correct surrounding spots with dead creatures" do
				game.creatures.clear
				game.creatures << creature_a
				game.creatures << creature_b
				expect(game.vacant_lots).to include([0, 0], [1, 0], [2, 0], [3, 0], [0, 1], [3, 1], [0, 2], [1, 2], [2, 2], [3, 2])
			end
		end

		context "with 2 diagonally adjacent live creatures" do
			it "populates the correct surrounding spots with dead creatures" do
				game.creatures.clear
				game.creatures << creature_a
				game.creatures << creature_c
				expect(game.vacant_lots).to include([0, 0], [1, 0], [2, 0], [0, 1], [2, 1], [3, 1], [0, 2], [1, 2], [3, 2], [1, 3], [2, 3], [3, 3])
			end
		end
	end

	describe "#increment_counter" do
		it "increments tick_count" do
			expect{ game.tick }.to change{ game.tick_count }.from(0).to(1)			
		end
	end
end