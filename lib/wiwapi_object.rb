class WIWAPIObject

  def initialize(connection, api_hash)
    @connection = connection

    # DateTime values need special parsing
    date_time_attributes = [:created_at, :updated_at] # assumes these are always present
    date_time_attributes += self.class.date_time_attributes
    for attr in date_time_attributes
      instance_variable_set("@#{attr}", DateTime.parse(api_hash.delete(attr.to_s)))
    end

    # then just do simple assignment of the rest of the attributes to
    # instance variables
    api_hash.each do |k, v|
      instance_variable_set "@#{k}".to_sym, v
    end
  end

end
