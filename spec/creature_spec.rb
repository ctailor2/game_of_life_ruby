require_relative '../creature'

describe Creature do
	describe "#alive" do
		context "when 'alive' is specified" do
			let(:creature) { Creature.new(2, 5, true) }

			it "is true" do
				expect(creature.alive).to be_true
			end
		end

		context "when 'alive' is not specified" do
			let(:creature) { Creature.new(2, 5) }

			it "is false" do
				expect(creature.alive).to be_false
			end
		end
	end

	describe "#location" do
		let(:creature) { Creature.new(2, 5) }

		it "returns its location as a pair of coordinates" do
			expect(creature.location).to eq([2, 5])
		end
	end

	describe "#live_neighbors" do
		let(:creature) { Creature.new(2, 5) }

		it "starts at zero" do
			expect(creature.live_neighbors).to eq(0)
		end
	end

	describe "#neighborhood" do
		let(:creature) { Creature.new(2, 5) }

		it "returns its 8 neighboring locations" do
			expect(creature.neighborhood).to include([1, 4], [1, 5], [1, 6], [2, 4], [2, 6], [3, 4], [3, 5], [3, 6])
		end
	end
end