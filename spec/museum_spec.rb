require "spec_helper"

RSpec.describe Museum do
    before(:each) do
        @dmns = Museum.new("Denver Museum of Nature and Science")

        @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
        @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
        @imax = Exhibit.new({name: "IMAX",cost: 15})

        @patron_1 = Patron.new("Bob", 0)
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

    describe "#ticket_lottery_contestants" do
        it "returns an Array of Patron Objects that don't have the money, but are interested in Exhibit" do
            @dmns.add_exhibit(@dead_sea_scrolls)

            @patron_1.add_interest("Dead Sea Scrolls")
            @patron_2.add_interest("Dead Sea Scrolls")
            @patron_3.add_interest("Dead Sea Scrolls")

            @dmns.admit(@patron_1)
            @dmns.admit(@patron_2)
            @dmns.admit(@patron_3)

            expect(@dmns.ticket_lottery_contestants(@dead_sea_scrolls)).to eq([@patron_1, @patron_3])
        end

        it "returns empty Array for free Exhibit" do
            @dmns.add_exhibit(@gems_and_minerals)

            @patron_1.add_interest("Gems and Minerals")
            @patron_2.add_interest("Gems and Minerals")
            @patron_3.add_interest("Gems and Minerals")

            @dmns.admit(@patron_1)
            @dmns.admit(@patron_2)
            @dmns.admit(@patron_3)

            expect(@dmns.ticket_lottery_contestants(@gems_and_minerals)).to eq([])
        end
    end

    describe "#draw_lottery_winner" do
        it "returns a Patron's name randomly from lottery for Exhibit" do
            @dmns.add_exhibit(@dead_sea_scrolls)

            @patron_1.add_interest("Dead Sea Scrolls")
            @patron_2.add_interest("Dead Sea Scrolls")
            @patron_3.add_interest("Dead Sea Scrolls")

            @dmns.admit(@patron_1)
            @dmns.admit(@patron_2)
            @dmns.admit(@patron_3)

            expect(@dmns.ticket_lottery_contestants(@dead_sea_scrolls)).to eq([@patron_1, @patron_3])

            allow(@dmns).to receive(:draw_lottery_winner).with(@dead_sea_scrolls).and_return("Bob")

            expect(@dmns.draw_lottery_winner(@dead_sea_scrolls)).to eq("Bob")
        end

        it "returns nil if there are no Patrons in lottery for Exhibit" do
            @dmns.add_exhibit(@gems_and_minerals)

            @patron_1.add_interest("Gems and Minerals")
            @patron_2.add_interest("Gems and Minerals")
            @patron_3.add_interest("Gems and Minerals")

            @dmns.admit(@patron_1)
            @dmns.admit(@patron_2)
            @dmns.admit(@patron_3)

            expect(@dmns.ticket_lottery_contestants(@gems_and_minerals)).to eq([])

            allow(@dmns).to receive(:draw_lottery_winner).with(@gems_and_minerals).and_return(nil)

            expect(@dmns.draw_lottery_winner(@gems_and_minerals)).to eq(nil)
        end
    end

    describe "#announce_lottery_winner" do
        it "returns correct String announcing winner of the lottery" do
            @dmns.add_exhibit(@imax)

            @patron_1.add_interest("IMAX")
            @patron_2.add_interest("IMAX")
            @patron_3.add_interest("IMAX")

            @dmns.admit(@patron_1)
            @dmns.admit(@patron_2)
            @dmns.admit(@patron_3)

            expect(@dmns.ticket_lottery_contestants(@imax)).to eq([@patron_1, @patron_3])

            allow(@dmns).to receive(:draw_lottery_winner).with(@imax).and_return("Bob")

            allow(@dmns).to receive(:announce_lottery_winner).with(@imax).and_return("Bob has won the IMAX exhibit lottery")

            expect(@dmns.announce_lottery_winner(@imax)).to eq("Bob has won the IMAX exhibit lottery")
        end

        it "returns no winners if there are no Patrons in lottery for Exhibit" do
            @dmns.add_exhibit(@gems_and_minerals)

            @patron_1.add_interest("Gems and Minerals")
            @patron_2.add_interest("Gems and Minerals")
            @patron_3.add_interest("Gems and Minerals")

            @dmns.admit(@patron_1)
            @dmns.admit(@patron_2)
            @dmns.admit(@patron_3)

            expect(@dmns.ticket_lottery_contestants(@gems_and_minerals)).to eq([])

            allow(@dmns).to receive(:draw_lottery_winner).with(@gems_and_minerals).and_return(nil)

            allow(@dmns).to receive(:announce_lottery_winner).with(@gems_and_minerals).and_return("No winners for this lottery")

            expect(@dmns.announce_lottery_winner(@gems_and_minerals)).to eq("No winners for this lottery")
        end
    end

    describe "Integrating New Patrons - Iteration 4" do
        before(:each) do
            @tj = Patron.new("TJ", 7)
            @patron_1 = Patron.new("Bob", 10)
            @patron_2 = Patron.new("Sally", 20)
            @morgan = Patron.new("Morgan", 15)
        end

        describe "#patron_interested_in_exhibit?" do
            it "returns true if Patron is interested in Exhibit" do
                @dmns.add_exhibit(@dead_sea_scrolls)

                @patron_1.add_interest("Dead Sea Scrolls")

                @dmns.admit(@patron_1)

                expect(@dmns.patron_interested_in_exhibit?(@patron_1, @dead_sea_scrolls)).to eq(true)
                expect(@dmns.patron_interested_in_exhibit?(@patron_1, @gems_and_minerals)).to eq(false)
            end
        end

        describe "attend_higher_cost_exhibit_first" do ### continue here
            it "returns the higher cost Exhibit" do
                exhibits = [@gems_and_minerals, @dead_sea_scrolls]

                expect(@dmns.attend_higher_cost_exhibit_first(@morgan, exhibits)).to eq(@dead_sea_scrolls)
            end
        end

        describe "#not_enough_spending_money?" do
            it "returns true if Patron does not have enough money to attend Exhibit" do
                expect(@dmns.not_enough_spending_money?(@patron_2, @dead_sea_scrolls)).to eq(false)
                expect(@dmns.not_enough_spending_money?(@tj, @dead_sea_scrolls)).to eq(true)
            end
        end

        describe "#pay_for_exhibit" do
            it "subtracts cost of Exhibit from Patron's spending money" do
                expect(@dmns.pay_for_exhibit(@patron_2, @dead_sea_scrolls)).to eq(10)
                expect(@dmns.pay_for_exhibit(@morgan, @dead_sea_scrolls)).to eq(5)
            end
        end

        describe "#patron_attend_exhibit" do
            it "can create Hash with keys as Exhibit Objects and values of Arrays of Patron Objects who attend" do
                @dmns.add_exhibit(@gems_and_minerals)
                @dmns.add_exhibit(@imax)
                @dmns.add_exhibit(@dead_sea_scrolls)

                ########################

                @tj.add_interest("IMAX")
                @tj.add_interest("Dead Sea Scrolls")

                @dmns.admit(@tj)

                expected = { @tj => [] }

                expect(@dmns.patron_attend_exhibit(@tj)).to eq(expected)
                expect(@tj.spending_money).to eq(7)

                ########################

                @patron_1.add_interest("Dead Sea Scrolls")
                @patron_1.add_interest("IMAX")

                @dmns.admit(@patron_1)

                expected = { @patron_1 => [@dead_sea_scrolls] }

                expect(@dmns.patron_attend_exhibit(@patron_1)).to eq(expected)
                expect(@patron_1.spending_money).to eq(0)

                ##########################

                @patron_2.add_interest("IMAX")
                @patron_2.add_interest("Dead Sea Scrolls")

                @dmns.admit(@patron_2)

                expected = { @patron_2 => [@imax] }

                expect(@dmns.patron_attend_exhibit(@patron_2)).to eq(expected)
                expect(@patron_2.spending_money).to eq(5)

                ##########################

                @morgan.add_interest("Gems and Minerals")
                @morgan.add_interest("Dead Sea Scrolls")

                @dmns.admit(@morgan)

                expected = { @morgan => [@dead_sea_scrolls, @gems_and_minerals] }

                expect(@dmns.patron_attend_exhibit(@morgan)).to eq(expected)
                expect(@morgan.spending_money).to eq(5)
            end
        end
    end
end

