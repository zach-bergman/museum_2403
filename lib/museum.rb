class Museum
    attr_reader :name, :exhibits

    def initialize(name)
        @name = name
        @exhibits = []
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
end