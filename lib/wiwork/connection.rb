module WhenIWork

  class Connection
    
    require 'httparty'
    include HTTParty

    BASE_URL = 'https://api.wheniwork.com/2/'

    NO_QUERY = nil

    attr_accessor :locations

    def initialize(token)
      @token = token
      test_connection_and_authentication

      @shifts = {}
      @users = {}
      @positions = {}
      @locations = nil

      log_connection if WhenIWork.configuration.logging
    end

    def wiwapi(verb, url_end, query=nil, body=nil)
      options = {}
      options[:headers] = {"W-Token" => @token} # required for all API hits

      query_string = (query ? assemble_query_string(query) : '')

      options[:body] = body.to_json if body     # this handles params for POSTs and PUTs

      log_request(verb, url_end, query_string, options) if WhenIWork.configuration.logging
      response = HTTParty.send(verb, BASE_URL + url_end + query_string, options)
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

    def log_request(verb, url_end, query_string, options)
      if defined? logger
        logger.tagged("wiwapi request") { logger.debug "#{verb.to_s.upcase} #{url_end + query_string}, body=#{options[:body]}" }
      else
        puts "\nwiwapi request: #{verb.to_s.upcase} #{url_end + query_string}, body=#{options[:body]}"
      end
    end

    def log_response(response)
      if defined? logger
        logger.tagged('wiwapi response') { logger.debug response.inspect }
      else
        puts "\nwiwapi response: #{response.inspect}"
      end
    end

    def log_connection
      if defined? logger
        logger.tagged("wiwapi connection") { logger.debug "initiated" }
      else
        puts "\nwiwapi connection: initiated"
      end
    end

    def assemble_query_string(query)
      items = []
      query.each do |k, v|
        if v.respond_to?(:each)
          item_string = "#{k}=#{v.join(',')}"
        else
          item_string = "#{k}=#{v}"
        end
        items << item_string
      end
      encoded_query_string = URI.encode('?' + items.join('&'))
      puts "*** query_string: #{encoded_query_string}"
      return encoded_query_string
    end      

  end

end