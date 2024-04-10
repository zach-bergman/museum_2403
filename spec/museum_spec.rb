require './lib/museum'
require './lib/patron'
require './lib/exhibit'

RSpec.describe Museum do
    before(:each) do
        @dmns = Museum.new("Denver Museum of Nature and Science")

        @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
        @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
        @imax = Exhibit.new({name: "IMAX",cost: 15})

        @patron_1 = Patron.new("Bob", 20)
        @patron_2 = Patron.new("Sally", 20)
        @patron_3 = Patron.new("Johnny", 5)
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
    
    describe "#admit" do
        it "can add Patron Objects to the patrons Array" do
            expect(@dmns.patrons).to eq([])

            @dmns.admit(@patron_1)
            @dmns.admit(@patron_2)
            @dmns.admit(@patron_3)

            expect(@dmns.patrons).to eq([@patron_1, @patron_2, @patron_3])
        end
    end

    describe "#patrons_by_exhibit_interest" do
        it "return a Hash with Exhibit Objects as keys and interested Patron Objects in Arrays as values" do
            @dmns.add_exhibit(@gems_and_minerals)
            @dmns.add_exhibit(@dead_sea_scrolls)
            @dmns.add_exhibit(@imax)

            @patron_1.add_interest("Gems and Minerals")
            @patron_1.add_interest("Dead Sea Scrolls")
            @patron_2.add_interest("Dead Sea Scrolls")
            @patron_3.add_interest("Dead Sea Scrolls")

            @dmns.admit(@patron_1)
            @dmns.admit(@patron_2)
            @dmns.admit(@patron_3)

            expected = {
                @gems_and_minerals => [@patron_1],
                @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
                @imax => []
            }

            expect(@dmns.patrons_by_exhibit_interest).to eq(expected)
        end
    end
end

