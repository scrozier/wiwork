module WhenIWork

  class Connection
    
    def locations
      return @locations.values if @locations
      parsed_response = wiwapi :get, 'locations'
      @locations = {}
      for hash in parsed_response['locations']
        new_object = Location.new(self, hash)
        @locations[new_object.id] = new_object
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
      parsed_response = wiwapi :post, 'locations', NO_QUERY, attributes
      hash = parsed_response['location']
      new_object = Location.new(@connection, hash)
      @locations[new_object.id] = new_object
      return new_object
    end

    def update_location(id, attributes)
      location = get_location(id)
      attributes.each do |k, v|
        raise WIWorkError, "#{k} is not a valid Location attribute" unless location.respond_to? k
      end
      parsed_response = wiwapi :put, "locations/#{id}", NO_QUERY, attributes
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