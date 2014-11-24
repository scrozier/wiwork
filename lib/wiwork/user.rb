module WhenIWork
  class Connection

    # "position_rates"=>{"874255"=>0}
    # "position_quality"=>{"874255"=>3}
    # "sort"=>{"301570"=>0}}
    # "alert_settings"=>{"timeoff"=>{"sms"=>false, "email"=>true}}

    # "swaps"=>{"sms"=>false, "email"=>true}
    # "schedule"=>{"sms"=>false, "email"=>true}
    # "reminders"=>{"sms"=>false, "email"=>true}
    # "availability"=>{"sms"=>false, "email"=>true}
    # "new_employee"=>{"sms"=>false, "email"=>true}
    # "attendance"=>{"sms"=>false, "email"=>false}}

    # avatar is not currently supported for external use
    class User

      attr_reader :id, :first_name, :last_name, :email, :phone_number,
        :hours_preferred, :hours_max, :hourly_rate, :role, :notes, :activated
      
      def initialize(connection, api_hash)
        @connection = connection

        @created_at = DateTime.parse(api_hash.delete('created_at'))
        @updated_at = DateTime.parse(api_hash.delete('updated_at'))

        # direct associations

        @position_ids = api_hash.delete('positions')
        @positions = nil

        @location_ids = api_hash.delete('locations')
        @locations = nil

        # associations available from other endpoints

        @availabilities = nil

        api_hash.delete('avatar') # see note above
        
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