module WhenIWork

  class Connection
    
    # this may be pretty close to production-ready
    def locations
      return @locations.values if @locations
      parsed_response = wiwapi :get, 'locations'
      @locations = {}
      for location_hash in parsed_response['locations']
        new_location = Location.new(self, location_hash)
        @locations[new_location.id] = new_location
      end
      return @locations.values
    end

    def get_location(id)
      # if we haven't gotten locations yet, get them all; otherwise, we
      # will wind up with @locations having just one location, but since
      # it's non-nil, it will look like the entire set
      locations unless @locations
      return @locations[id] if @locations[id]
      # since we're keeping @locations in sync with our creates, updates,
      # and deletes, it should match the WhenIWork list as far as we're
      # concerned
      return (@locations[id] ? @locations[id] : nil)
    end

    def create_location(attributes)
      parsed_response = wiwapi :post, 'locations', attributes
      location_hash = parsed_response['location']
      location = Location.new(@connection, location_hash)
      @locations[location.id] = location
      return location
    end

    def update_location(id, attributes)
      location = get_location(id)
      attributes.each do |k, v|
        raise WIWorkError, "#{k} is not a valid Location attribute" unless location.respond_to? k
      end
      parsed_response = wiwapi :put, "locations/#{id}", attributes
      @locations[id] = Location.new(self, parsed_response['location'])
      return @locations[id]
    end

    def delete_location(id)
      parsed_response = wiwapi :delete, "locations/#{id}"
      if parsed_response['success']
        @locations.delete(id)
        return true
      else
        return false
      end
    end

  end

end