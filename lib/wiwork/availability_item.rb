module WhenIWork
  class AvailabilityItem
    attr_reader :id, :availability_id, :user_id, :day, :type, :start_time,
      :end_time, :created_at, :updated_at, :name, :description,
      :start_date, :end_date, :ongoing, :repeat

    def initialize(connection, api_hash)
      @created_at = DateTime.parse(api_hash.delete('created_at'))
      @updated_at = DateTime.parse(api_hash.delete('updated_at'))
      @start_time = Time.parse(api_hash.delete('start_time'))
      @end_time = Time.parse(api_hash.delete('end_time'))
      api_hash.each do |k, v|
        instance_variable_set "@#{k}".to_sym, v
      end
    end
  end
end
