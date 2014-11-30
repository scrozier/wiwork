module WhenIWork

  class Connection
    
    require 'httparty'
    include HTTParty

    BASE_URL = 'https://api.wheniwork.com/2/'

    attr_accessor :locations

    def initialize(token)
      @token = token
      test_connection_and_authentication

      @users = {}
      @positions = {}
      @locations = nil
      @shifts = {}
    end

    def wiwapi(verb, url_end, body=nil)
      options = {}
      options[:headers] = {"W-Token" => @token} # required for all API hits
      options[:body] = body.to_json if body     # this handles params for POSTs and PUTs

      log_request(verb, url_end, options) if WhenIWork.configuration.logging
      response = HTTParty.send(verb, BASE_URL + url_end, options)
      log_response(response) if WhenIWork.configuration.logging

      parsed_response = response.parsed_response
      if response.code != 200
        raise WhenIWork::WIWAPIError, "#{parsed_response['code']} #{parsed_response['error']}"
      end
      
      return parsed_response
    end

    private

    def test_connection_and_authentication
      # test connection/authentication so that we fail early, if necessary;
      # use this call, which should succeed on the authentication level,
      # but not return a big response (using locations/0 seems to return
      # all locations)
      options = {}
      options[:headers] = {"W-Token" => @token}
      response = HTTParty.send(:get, BASE_URL + 'locations/1', options)
      # if we're authenticating OK, should get a 4003 code from API
      parsed_response = response.parsed_response      
      unless parsed_response['code'] == '4003'
        raise WIWorkError, 'Unable to connect to WhenIWork API; probably a bad token'
      end
    end

    def log_request(verb, url_end, options)
      if defined? logger
        logger.tagged("wiwapi request") { logger.debug "#{verb.to_s.upcase} #{url_end}, body=#{options[:body]}" }
      else
        puts "\nwiwapi request: #{verb.to_s.upcase} #{url_end}, body=#{options[:body]}"
      end
    end

    def log_response(response)
      if defined? logger
        logger.tagged('wiwapi response') { logger.debug response.inspect }
      else
        puts "\nwiwapi response: #{response.inspect}"
      end
    end

  end

end