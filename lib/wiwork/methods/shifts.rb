module WhenIWork

  class Connection
    
    def create_shift(location_id, start_time, end_time, notes)
      response = HTTParty.post BASE_URL + 'shifts',
        body: {location_id: location_id, start_time: start_time, end_time: end_time, notes: notes}.to_json,
        headers: {"W-Token" => @token}
    end

  end

end