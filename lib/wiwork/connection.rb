module WhenIWork

  class Connection
    
    require 'httparty'
    include HTTParty

    BASE_URL = 'https://api.wheniwork.com/2/'

    def initialize(token)
      @token = token
      @positions = {}
      @locations = {}
    end

    def create_shift(location_id, start_time, end_time, notes)
      response = HTTParty.post BASE_URL + 'shifts',
        body: {location_id: location_id, start_time: start_time, end_time: end_time, notes: notes}.to_json,
        headers: {"W-Token" => @token}
    end

    def positions
      response = HTTParty.get BASE_URL + 'positions', headers: {"W-Token" => @token}
      return nil unless response.code == 200
      positions = []
      for position_hash in response.parsed_response['positions']
        positions << Position.new(position_hash)
      end
      return positions
    end

    def get_position(id)
      return @positions[id] if @positions[id]
      response = HTTParty.get BASE_URL + "positions/#{id}", headers: {"W-Token" => @token}
      return nil unless response.code == 200
      @positions[id] = Position.new(response.parsed_response['position'])
    end

    # this may be pretty close to production-ready
    def locations
      response = HTTParty.get BASE_URL + 'locations', headers: {"W-Token" => @token}
      return nil unless response.code == 200
      locations = []
      for location_hash in response.parsed_response['locations']
        locations << Location.new(location_hash)
      end
      return locations
    end

    def get_location(id)
      return @locations[id] if @locations[id]
      response = HTTParty.get BASE_URL + "locations/#{id}", headers: {"W-Token" => @token}
      return nil unless response.code == 200
      @locations[id] = Location.new(response.parsed_response['location'])
    end

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