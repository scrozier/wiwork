module WhenIWork

  class Connection
    
    # this may be pretty close to production-ready
    def locations
      response = HTTParty.get BASE_URL + 'locations', headers: {"W-Token" => @token}
      return nil unless response.code == 200
      locations = []
      for location_hash in response.parsed_response['locations']
        locations << Location.new(location_hash)
      end
      return locations
    end

    def get_location(id)
      return @locations[id] if @locations[id]
      response = HTTParty.get BASE_URL + "locations/#{id}", headers: {"W-Token" => @token}
      return nil unless response.code == 200
      @locations[id] = Location.new(response.parsed_response['location'])
    end

  end

end