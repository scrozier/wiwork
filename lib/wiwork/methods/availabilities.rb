module WhenIWork

  class Connection
    
    def availabilities(users, start_datetime, end_datetime)
      response = HTTParty.get URI.encode(BASE_URL + "availabilities/items?user_id=#{users.inspect}&start=#{start_datetime}&end=#{end_datetime}"),
        headers: {"W-Token" => @token}
      return nil unless response.code == 200
      return response.parsed_response['availabilities']
      availabilities = []
      for availability_hash in response.parsed_response['availabilities']
        availabilities << Availability.new(availability_hash)
      end
      return availabilities
    end      

  end

end