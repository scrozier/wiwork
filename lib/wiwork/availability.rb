module WhenIWork
  class Availability
    attr_reader :id, :availability_id, :user_id, :day, :type, :created_at,
      :updated_at, :name, :description, :start_date, :end_date, :ongoing,
      :repeat

    def initialize(connection, api_hash)
      @connection = connection
      
      @created_at = DateTime.parse(api_hash.delete('created_at'))
      @updated_at = DateTime.parse(api_hash.delete('updated_at'))
      @start_date = DateTime.parse(api_hash.delete('start_date'))
      @end_date = DateTime.parse(api_hash.delete('end_date'))
      api_hash.each do |k, v|
        instance_variable_set "@#{k}".to_sym, v
      end

      @availability_items = nil
    end

    # availability_items is initialized to nil; the first time it is invoked,
    # it hits the api and retrieves the availability_items as an array (which
    # may be empty) into @availability_items
    def availability_items
      return @availability_items if @availability_items
      @availability_items = @connection.availability_items(self.id)
    end

  end
end
