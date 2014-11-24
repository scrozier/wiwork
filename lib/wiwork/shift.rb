module WhenIWork
  class Shift
    attr_reader :id, :start_time, :end_time, :notes, :created_at, :updated_at

    def initialize(connection, api_hash)
      @connection = connection

      @created_at = DateTime.parse(api_hash.delete('created_at'))
      @updated_at = DateTime.parse(api_hash.delete('updated_at'))
      @start_time = DateTime.parse(api_hash.delete('start_time'))
      @end_time = DateTime.parse(api_hash.delete('end_time'))
      
      api_hash.each do |k, v|
        instance_variable_set "@#{k}".to_sym, v
      end
    end
  end
end
