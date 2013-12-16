require_relative '../game'

describe Game do
	let(:game) { Game.new(5) }
	let(:live_a) { Creature.new(1, 1, true) }
	let(:live_b) { Creature.new(2, 1, true) }
	let(:live_c) { Creature.new(2, 2, true) }
	let(:live_d) { Creature.new(3, 1, true) }
	let(:live_e) { Creature.new(3, 0, true) }
	let(:live_f) { Creature.new(4, 2, true) }
	let(:dead_a) { Creature.new(1, 0) }
	let(:dead_b) { Creature.new(3, 3) }
	let(:dead_c) { Creature.new(1, 2) }
	let(:dead_d) { Creature.new(0, 0) }
	let(:dead_e) { Creature.new(1, 4) }
	let(:dead_f) { Creature.new(4, 1) }

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
				game.creatures.push(live_a)
				expect(game.vacant_lots).to include([0, 0], [1, 0], [2, 0], [0, 1], [2, 1], [0, 2], [1, 2], [2, 2])
			end
		end

		context "with 2 adjacent live creatures" do
			it "returns the correct set of locations" do
				game.creatures.push(live_a, live_b)
				expect(game.vacant_lots).to include([0, 0], [1, 0], [2, 0], [3, 0], [0, 1], [3, 1], [0, 2], [1, 2], [2, 2], [3, 2])
			end
		end

		context "with 2 diagonally adjacent live creatures" do
			it "returns the correct set of locations" do
				game.creatures.push(live_a, live_c)
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
			game.creatures.push(live_a, live_b, live_c, dead_a, dead_b, dead_c, dead_d)
		end

		context "for live_b" do
			it "returns the correct number of live neighbors" do
				expect(game.count_neighbors(live_b)).to eq(2)
			end
		end

		context "for dead_a" do
			it "returns the correct number of live neighbors" do
				expect(game.count_neighbors(dead_a)).to eq(2)
			end
		end

		context "for dead_c" do
			it "returns the correct number of live neighbors" do
				expect(game.count_neighbors(dead_c)).to eq(3)
			end
		end

		context "for dead_d" do
			it "returns the correct number of live neighbors" do
				expect(game.count_neighbors(dead_d)).to eq(1)
			end
		end
	end

	describe "#set_neighbor_counts" do
		before do
			game.creatures.clear
			game.creatures.push(live_a, live_b, live_c, dead_a)
		end

		it "sets the live_neighbors attribute for all creatures" do
			game.set_neighbor_counts
			expect(game.creatures.all? { |creature| creature.live_neighbors == 2 }).to be_true
		end
	end

	describe "#select_live_to_die" do
		before do
			game.creatures.clear
			game.creatures.push(live_a, live_b, live_c, live_d, live_e, live_f, dead_a, dead_b, dead_c, dead_d, dead_e, dead_f)
			game.set_neighbor_counts
		end

		context "for creatures with less than 2 live neighbors" do
			it "returns these creatures" do
				expect(game.select_live_to_die).to include(live_f)
			end

			it "removes these creatures from the collection" do
				game.select_live_to_die
				expect(game.creatures).not_to include(live_f)
			end
		end

		context "for creatures with greater than 3 live neighbors" do
			it "returns these creatures" do
				expect(game.select_live_to_die).to include(live_b, live_d)
			end

			it "removes these creatures from the collection" do
				game.select_live_to_die
				expect(game.creatures).not_to include(live_b, live_d)
			end
		end
	end

	describe "#select_dead_to_live" do
		before do
			game.creatures.clear
			game.creatures.push(live_a, live_b, live_c, live_d, live_e, live_f, dead_a, dead_b, dead_c, dead_d, dead_e, dead_f)
			game.set_neighbor_counts
		end

		context "for creatures with exactly 3 live neighbors" do
			it "returns these creatures" do
				expect(game.select_dead_to_live).to include(dead_c, dead_f)
			end

			it "removes these creatures from the collection" do
				game.select_dead_to_live
				expect(game.creatures).not_to include(dead_c, dead_f)
			end
		end
	end

	describe "#zap_select_creatures" do
		before do
			game.creatures.clear
			game.creatures.push(live_a, live_b, live_c, live_d, live_e, live_f, dead_a, dead_b, dead_c, dead_d, dead_e, dead_f)
			game.set_neighbor_counts			
		end

		context "on live creatures" do
			it "kills them" do
				game.zap_select_creatures
				expect(live_b.alive).to be_false
			end
		end

		context "on dead creatures" do
			it "brings them to life" do
				game.zap_select_creatures
				expect(dead_c.alive).to be_true
			end
		end

		context "when completed" do
			it "adds the zapped creatures back to the collection" do
				game.zap_select_creatures
				expect(game.creatures).to include(live_b, live_d, dead_c, dead_f)
			end
		end
	end
end