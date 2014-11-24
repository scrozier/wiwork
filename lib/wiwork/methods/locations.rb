module WhenIWork

  class Connection
    
    # this may be pretty close to production-ready
    def locations
      parsed_response = wiwapi :get, 'locations'
      locations = []
      for location_hash in parsed_response['locations']
        locations << Location.new(self, location_hash)
      end
      return locations
    end

    def get_location(id)
      return @locations[id] if @locations[id]
      parsed_response = wiwapi :get, "locations/#{id}"
      @locations[id] = Location.new(self, parsed_response['location'])
    end

  end

end