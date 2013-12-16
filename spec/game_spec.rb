require_relative '../game'

describe Game do
	let(:game) { Game.new(5) }
	let(:creature_a) { Creature.new(1, 1, true) }
	let(:creature_b) { Creature.new(2, 1, true) }
	let(:creature_c) { Creature.new(2, 2, true) }
	let(:creature_d) { Creature.new(1, 0) }
	let(:creature_e) { Creature.new(3, 3) }
	let(:creature_f) { Creature.new(1, 2) }
	let(:creature_g) { Creature.new(0, 0) }

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

	describe "#vacant_lots" do
		before { game.creatures.clear }

		context "with 1 live creature" do
			it "returns the correct set of locations" do
				game.creatures.push(creature_a)
				expect(game.vacant_lots).to include([0, 0], [1, 0], [2, 0], [0, 1], [2, 1], [0, 2], [1, 2], [2, 2])
			end
		end

		context "with 2 adjacent live creatures" do
			it "returns the correct set of locations" do
				game.creatures.push(creature_a, creature_b)
				expect(game.vacant_lots).to include([0, 0], [1, 0], [2, 0], [3, 0], [0, 1], [3, 1], [0, 2], [1, 2], [2, 2], [3, 2])
			end
		end

		context "with 2 diagonally adjacent live creatures" do
			it "returns the correct set of locations" do
				game.creatures.push(creature_a, creature_c)
				expect(game.vacant_lots).to include([0, 0], [1, 0], [2, 0], [0, 1], [2, 1], [3, 1], [0, 2], [1, 2], [3, 2], [1, 3], [2, 3], [3, 3])
			end
		end
	end

	describe "#build_neighborhood" do
		before { game.creatures.clear }

		it "creates dead creatures at the specified locations" do
			game.build_neighborhood([[0, 0], [1, 0], [2, 0]])
			expect(game.creature_locations(false)).to include([0, 0], [1, 0], [2, 0])
		end
	end

	describe "#increment_counter" do
		it "increments tick_count" do
			expect{ game.tick }.to change{ game.tick_count }.by(1)		
		end
	end

	describe "#count_neighbors" do
		before do
			game.creatures.clear
			game.creatures.push(creature_a, creature_b, creature_c, creature_d, creature_e, creature_f, creature_g)
		end

		context "for creature_b" do
			it "returns the correct number of live neighbors" do
				expect(game.count_neighbors(creature_b)).to eq(2)
			end
		end

		context "for creature_d" do
			it "returns the correct number of live neighbors" do
				expect(game.count_neighbors(creature_d)).to eq(2)
			end
		end

		context "for creature_f" do
			it "returns the correct number of live neighbors" do
				expect(game.count_neighbors(creature_f)).to eq(3)
			end
		end

		context "for creature_g" do
			it "returns the correct number of live neighbors" do
				expect(game.count_neighbors(creature_g)).to eq(1)
			end
		end
	end
end