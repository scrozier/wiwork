module WhenIWork
  class AvailabilityItem
    attr_reader :id, :availability_id, :user_id, :day, :type, :start_time,
      :end_time, :created_at, :updated_at, :name, :description,
      :start_date, :end_date, :ongoing, :repeat

    def initialize(connection, api_hash)
      @connection = connection

      @created_at = DateTime.parse(api_hash.delete('created_at'))
      @updated_at = DateTime.parse(api_hash.delete('updated_at'))
      @start_time = Time.parse(api_hash.delete('start_time'))
      @end_time = Time.parse(api_hash.delete('end_time'))
      api_hash.each do |k, v|
        instance_variable_set "@#{k}".to_sym, v
      end

      @user = nil
    end

    def user
      return @user if @user
      return @connection.get_existing_user(@user_id)
    end

    def type_in_words
      return case @type
      when 1
        'Unavailable'
      when 2
        'Preferred'
      else
        '*unexpected value for type*'
      end
    end
  end
end
