class Museum
    attr_reader :name, 
                :exhibits,
                :patrons

    def initialize(name)
        @name = name
        @exhibits = []
        @patrons = []
        @revenue = 0
    end

    def add_exhibit(exhibit)
        @exhibits << exhibit
    end

    def recommend_exhibits(patron)
        patron.interests.map do |interest|
            @exhibits.find do |exhibit|
                exhibit.name == interest
            end
        end
    end

    def admit(patron)
        @patrons << patron
    end

    def patrons_by_exhibit_interest
        hash = {
            @exhibits[0] => [],
            @exhibits[1] => [],
            @exhibits[2] => []
        }
        hash.each do |exhibit, patrons_array|
            @patrons.each do |patron|
                patrons_array << patron if patron.interests.include?(exhibit.name)
            end
        end
        hash
    end

    def ticket_lottery_contestants(exhibit)
        @patrons.select do |patron|
            if patron.interests.include?(exhibit.name) && patron.spending_money < exhibit.cost
                patron
            end
        end
    end

    def draw_lottery_winner(exhibit)
        ticket_lottery_contestants(exhibit).sample.name
    end

    def announce_lottery_winner(exhibit)
        if draw_lottery_winner(exhibit) != nil
            "#{draw_lottery_winner(exhibit)} has won the #{exhibit.name} lottery"
        else
            "No winners for the lottery"
        end
    end

    def patron_interested_in_exhibit?(patron, exhibit)
        patron.interests.include?(exhibit.name)
    end

    def not_enough_spending_money?(patron, exhibit)
        patron.spending_money < exhibit.cost
    end

    def pay_for_exhibit(patron, exhibit)
        patron.spending_money - exhibit.cost
    end

    def attend_higher_cost_exhibit_first(patron, exhibits)
        exhibits.max_by do |exhibit|
            exhibit.cost
        end
    end

    def patron_attend_exhibit(patron)
        attend = Hash.new { |hash, key| hash[key] = [] }
        @exhibits.each do |exhibit|
            if patron_interested_in_exhibit?(patron, exhibit) && !not_enough_spending_money?(patron, exhibit)
                attend = attend[patron] = attend_higher_cost_exhibit_first(patron, exhibit)
            end
        end
        attend
        # pay_for_exhibit(patron, attend[patron])
        # @revenue += pay_for_exhibit(patron, attend[patron])
    end
end