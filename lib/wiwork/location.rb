module WhenIWork

  class Location

    def initialize(connection, api_hash)
      @connection = connection
      @created_at = DateTime.parse(api_hash.delete('created_at'))
      @updated_at = DateTime.parse(api_hash.delete('updated_at'))
      api_hash.each do |k, v|
        instance_variable_set "@#{k}".to_sym, v
        define_singleton_method(k) { instance_variable_get "@#{k}" }
      end
    end

  end

end
