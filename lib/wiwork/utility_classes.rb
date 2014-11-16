module WhenIWork

  class DateTimeFormatter
    def self.for_query(dt)
      dt.strftime('%Y-%m-%d %I:%M%P')
    end
  end

  class WIWAPIError < StandardError
  end

  class Avatar
    attr_reader :url, :size
    def initialize(hash)
      @url = hash['url']
      @size = hash['size']
    end
  end

end