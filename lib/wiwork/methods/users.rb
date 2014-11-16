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

    def get_existing_user(id)
      return @users[id] if @users[id]
      response = HTTParty.get BASE_URL + "users/#{id}", headers: {"W-Token" => @token}
      return nil unless response.code == 200
      @users[id] = User.new(self, response.parsed_response['user'])
    end

  end

end