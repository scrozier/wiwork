module WhenIWork

  class Connection

    private

    def validate_options(valid_options, options)
      unless (options.keys - valid_options).empty?
        raise WhenIWork::WIWorkError, "Invalid option(s): #{options.inspect}"
      end
    end

  end

  class DateTimeFormatter
    def self.for_query(dt)
      dt.strftime('%Y-%m-%d %I:%M%P')
    end
  end

  class DateFormatter
    def self.for_query(d)
      d.strftime('%Y-%m-%d')
    end
  end

  class WIWorkError < StandardError
  end

  class WIWAPIError < StandardError
  end

end