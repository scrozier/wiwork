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

    # "avatar"=>{"url"=>"http://avatar.wheniwork.com/wiw/1700404.png?s=%s&t=1700404", "size"=>"%s"},
    class User
      attr_reader :id, :login_id, :timezone_id, :country_id,
        :migration_id, :role, :is_payroll, :is_trusted, :type, :email,
        :first_name, :last_name, :phone_number, :employee_code, :avatar,
        :password, :activated, :is_hidden, :uuid, :notes, :affiliate,
        :is_private, :infotips, :hours_preferred, :hours_max, :hourly_rate,
        :alert_settings, :reminder_time, :sleep_start, :sleep_end, :my_positions,
        :last_login, :notified_at, :created_at, :updated_at, :is_deleted,
        :login_email, :positions, :locations, :position_rates, :position_quality,
        :sort
      def initialize(connection, api_hash)
        @connection = connection

        @created_at = DateTime.parse(api_hash.delete('created_at'))
        @updated_at = DateTime.parse(api_hash.delete('updated_at'))

        position_ids = api_hash.delete('positions')
        @positions = []
        for position_id in position_ids
          @positions << connection.get_position(position_id)
        end

        location_ids = api_hash.delete('locations')
        @locations = []
        for location_id in location_ids
          @locations << connection.get_location(location_id)
        end

        @availabilities = nil

        avatar_hash = api_hash.delete('avatar')
        @avatar = Avatar.new(avatar_hash)
        
        api_hash.each do |k, v|
          instance_variable_set "@#{k}".to_sym, v
        end
      end

      # availabilities is initialized to nil; the first time it is invoked,
      # it hits the api and retrieves the availabilities as an array (which
      # may be empty) into @availabilities
      def availabilities
        return @availabilities if @availabilities
        @availabilities = @connection.availabilities(self.id)
      end

    end

  end
end