class Museum
    attr_reader :name, 
                :exhibits,
                :patrons

    def initialize(name)
        @name = name
        @exhibits = []
        @patrons = []
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
        ticket_lottery_contestants(exhibit).sample
    end
end