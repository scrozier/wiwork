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

  end

end