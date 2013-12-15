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

			it "does not raise an error" do
				expect(creature).not_to raise_error
			end

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
end