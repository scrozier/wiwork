module WhenIWork

  class Connection
    
    def positions
      response = HTTParty.get BASE_URL + 'positions', headers: {"W-Token" => @token}
      return nil unless response.code == 200
      positions = []
      for position_hash in response.parsed_response['positions']
        positions << Position.new(position_hash)
      end
      return positions
    end

    def get_position(id)
      return @positions[id] if @positions[id]
      response = HTTParty.get BASE_URL + "positions/#{id}", headers: {"W-Token" => @token}
      return nil unless response.code == 200
      @positions[id] = Position.new(response.parsed_response['position'])
    end

  end

end