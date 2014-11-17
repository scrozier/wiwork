module WhenIWork
  class Location
    attr_reader :id, :is_default, :name, :sort, :max_hours,
      :address, :coordinates, :latitude, :longitude, :ip_address, :created_at,
      :updated_at, :is_deleted

    def initialize(connection, api_hash)
      @connection = connection
      @created_at = DateTime.parse(api_hash.delete('created_at'))
      @updated_at = DateTime.parse(api_hash.delete('updated_at'))
      api_hash.each do |k, v|
        instance_variable_set "@#{k}".to_sym, v
      end
    end
  end
end
