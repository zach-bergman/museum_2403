require './lib/museum'
require './lib/patron'
require './lib/exhibit'

RSpec.describe Patron do
    before(:each) do
        @dmns = Museum.new("Denver Museum of Nature and Science")

        @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
        @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
        @imax = Exhibit.new({name: "IMAX",cost: 15})

        @patron_1 = Patron.new("Bob", 20)
        @patron_2 = Patron.new("Sally", 20)
    end

    describe "#initialize" do
        it "exists" do
            expect(@dmns).to be_an_instance_of(Museum)
        end

        it "has a name" do
            expect(@dmns.name).to eq("Denver Museum of Nature and Science")
        end

        it "can store exhibits" do
            expect(@dmns.exhibits).to eq([])
        end

        it "can store patrons" do
            expect(@dmns.patrons).to eq([])
        end
    end

    describe "#add_exhibit" do
        it "can add exhibit Objects to the exhibits array" do
            expect(@dmns.exhibits).to eq([])

            @dmns.add_exhibit(@gems_and_minerals)
            @dmns.add_exhibit(@dead_sea_scrolls)
            @dmns.add_exhibit(@imax)

            expect(@dmns.exhibits).to eq([@gems_and_minerals, @dead_sea_scrolls, @imax])
        end
    end

    describe "#recommend_exhibits" do
        it "returns an array of exhibit Objects that match a Patron's interests" do
            @dmns.add_exhibit(@gems_and_minerals)
            @dmns.add_exhibit(@dead_sea_scrolls)
            @dmns.add_exhibit(@imax)

            @patron_1.add_interest("Dead Sea Scrolls")
            @patron_1.add_interest("Gems and Minerals")

            @patron_2.add_interest("IMAX")

            expect(@dmns.recommend_exhibits(@patron_1)).to eq([@dead_sea_scrolls, @gems_and_minerals])
            expect(@dmns.recommend_exhibits(@patron_2)).to eq([@imax])
        end
    end
end

