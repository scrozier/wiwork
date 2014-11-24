module WhenIWork

  class Connection
    
    require 'httparty'
    include HTTParty

    BASE_URL = 'https://api.wheniwork.com/2/'

    def initialize(token)
      @token = token
      @positions = {}
      @locations = {}
      @users = {}
      @shifts = {}
    end

    def wiwapi(verb, url_end, body=nil)
      options = {}
      options[:headers] = {"W-Token" => @token} # required for all API hits
      options[:body] = body.to_json if body     # this handles params for POSTs and PUTs

      if defined? logger
        logger.tagged('wiwapi request') { logger.debug "#{url_end}, body=#{options[:body]}" }
      else
        puts "wiwapi request: #{url_end}, body=#{options[:body]}"
      end

      response = HTTParty.send(verb, BASE_URL + url_end, options)

      if defined? logger
        logger.tagged('wiwapi response') { logger.debug response.inspect }
      else
        puts "wiwapi response: #{response.inspect}"
      end

      parsed_response = response.parsed_response

      if response.code != 200
        raise WhenIWork::WIWAPIError, "#{parsed_response['code']} #{parsed_response['error']}"
      end
      
      return parsed_response
    end

  end

end