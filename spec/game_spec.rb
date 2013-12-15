require_relative '../game'

describe Game do
	describe "#creatures" do
		let(:game) { Game.new(5) }

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
		let(:game) { Game.new(5) }

		it "returns the correct number of locations" do
			expect(game.starting_locations(10).length).to eq(10)
		end

		it "returns a set of unique locations" do
			expect(game.starting_locations(10).uniq.length).to eq(10)
		end
	end

	describe "#starting_bound" do
		let(:game) { Game.new(6) }

		it "ensures creatures take up at least 20% of their starting area" do
			num_creatures = game.creatures.length
			expect(num_creatures.to_f / (game.starting_bound(6) ** 2)).to be >= 0.20
		end
	end

	
end