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
    end
end

