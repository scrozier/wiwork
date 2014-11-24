module WhenIWork

  class Connection
    
    # this endpoint, with no query string, appears to return a single
    # availability...don't know which one it is; so essentially, I'm going
    # to treat user_ids as required
    def availabilities(user_ids)
      raise ArgumentError unless user_ids
      query_params = []

      if user_ids.respond_to?(:each)
        query_string = "user_id=#{user_ids.join(',')}"
      else
        query_string = "user_id=#{user_ids}"
      end 

      parsed_response = wiwapi :get, URI.encode("availabilities#{query_string}")
      availabilities = []
      for availability_hash in parsed_response['availabilities']
        availabilities << Availability.new(self, availability_hash)
      end
      return availabilities
    end

    # this endpoint *can* be called without a user_id, which appears to
    # return availability_items for all users
    def availability_items(user_ids=nil, start_datetime=nil, end_datetime=nil)
      raise ArgumentError if (start_datetime && !end_datetime) || (end_datetime && !start_datetime)

      query_params = []

      user_id_param = case
      when user_ids.nil?
        nil
      when user_ids.respond_to?(:each)
        "user_id=#{user_ids.join(',')}"
      else
        "user_id=#{user_ids}"
      end 
      query_params << user_id_param if user_id_param

      if start_datetime
        query_params << "start=#{DateTimeFormatter.for_query(start_datetime)}"
        query_params << "end=#{DateTimeFormatter.for_query(end_datetime)}"
      end

      query_string = query_params.empty? ? '' : '?' + query_params.collect{|p| "#{p}"}.join('&')

      parsed_response = wiwapi :get, URI.encode("availabilities/items#{query_string}")
      availability_items = []
      for availability_items_hash in parsed_response['availabilityitems']
        availability_items << AvailabilityItem.new(self, availability_items_hash)
      end
      return availability_items
    end
  end

end