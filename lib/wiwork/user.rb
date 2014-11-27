module WhenIWork
  class Connection
    class User

      attr_reader :id, :first_name, :last_name, :email, :phone_number,
        :hours_preferred, :hours_max, :hourly_rate, :role, :notes, :activated
      
      def initialize(connection, api_hash)
        @connection = connection

        # direct associations

        @position_ids = api_hash.delete('positions')
        @positions = nil

        @location_ids = api_hash.delete('locations')
        @locations = nil

        # associations available from other endpoints

        @availabilities = nil

        # we're saving all the fields from the API response, but note that
        # we only have attr_readers for those listed in the API doc
        api_hash.each do |k, v|
          instance_variable_set "@#{k}".to_sym, v
        end
      end

      def positions
        return @positions if @positions
        @positions = []
        for position_id in @position_ids
          @positions << @connection.get_position(position_id)
        end
        return @positions
      end

      def locations
        return @locations if @locations
        @locations = []
        for location_id in location_ids
          @locations << @connection.get_location(location_id)
        end
        return @locations
      end

      def availabilities
        return @availabilities if @availabilities
        @availabilities = @connection.list_availabilities(self.id)
      end

    end
  end
end