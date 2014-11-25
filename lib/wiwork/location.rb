module WhenIWork
  class Location
    attr_reader :id, :is_default, :name, :sort, :max_hours,
      :address, :coordinates, :latitude, :longitude, :ip_address, :is_deleted

    def initialize(connection, api_hash)
      @connection = connection
      api_hash.each do |k, v|
        instance_variable_set "@#{k}".to_sym, v
      end
    end

    def Location.create(connection, values_hash)
      parsed_response = connection.wiwapi :post, 'locations', values_hash
      location_hash = parsed_response['location']
      location = Location.new(@connection, location_hash)
      @connection.locations[location.id] = location
      return location
    end

    def delete
      parsed_response = @connection.wiwapi :delete, "locations/#{self.id}"
      @connection.locations.delete self.id
    end

  end
end
