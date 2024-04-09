class Exhibit
    attr_reader :name, :cost
    
    def initialize(details)
        @name = details[:name]
        @cost = details[:cost]
    end
end