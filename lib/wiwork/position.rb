module WhenIWork

  class Position
    attr_reader :id, :name, :color
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
