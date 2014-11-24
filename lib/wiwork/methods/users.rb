module WhenIWork

  class Connection
    
    def users
      parsed_response = wiwapi :get, 'users'
      users = []
      for user_hash in parsed_response['users']
        users << User.new(self, user_hash)
      end
      return users
    end

    def get_existing_user(id)
      return @users[id] if @users[id]
      parsed_response = wiwapi :get, "users/#{id}"
      @users[id] = User.new(self, parsed_response['user'])
    end

  end

end