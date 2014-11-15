module WhenIWork

  class Connection
    
    def users
      response = HTTParty.get BASE_URL + 'users', headers: {"W-Token" => @token}
      return nil unless response.code == 200
      users = []
      for user_hash in response.parsed_response['users']
        users << User.new(self, user_hash)
      end
      return users
    end

  end

end