module WhenIWork

  class Connection
    
    def positions
      parsed_response = wiwapi :get, 'positions'
      positions = []
      for position_hash in parsed_response['positions']
        positions << Position.new(self, position_hash)
      end
      return positions
    end

    def get_position(id)
      return @positions[id] if @positions[id]
      parsed_response = wiwapi :get, "positions/#{id}"
      @positions[id] = Position.new(self, parsed_response['position'])
    end

  end

end