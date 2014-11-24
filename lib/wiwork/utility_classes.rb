module WhenIWork

  class DateTimeFormatter
    def self.for_query(dt)
      dt.strftime('%Y-%m-%d %I:%M%P')
    end
  end

  class WIWAPIError < StandardError
  end

end