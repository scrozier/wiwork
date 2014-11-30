class WIWAPIObject

  def initialize(connection, api_hash)
    @connection = connection

    @created_at = DateTime.parse(api_hash.delete('created_at'))
    @updated_at = DateTime.parse(api_hash.delete('updated_at'))

    api_hash.each do |k, v|
      instance_variable_set "@#{k}".to_sym, v
    end
  end

  def method_missing(name, *args, &block)
    instance_variable_get "@#{name}"
  end

  def respond_to?(name)
    true
  end

end
