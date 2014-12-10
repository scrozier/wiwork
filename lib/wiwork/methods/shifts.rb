module WhenIWork
  class Connection

    # because one can use the API to get a filtered list of shifts, we
    # always hit the API for this call; we *do* store the returned shifts,
    # even though they may not be a full set, because we can use them
    # to retrieve single shifts by id with get_shift
    #
    # Undocumented, per WIW, 2014-12-03: To retrieve unpublished shifts
    # you'll want to include unpublished=1 to your string. Also, by default
    # the API doesn't return Open Shifts. If you want to include those, you
    # add include_allopen=1 to your request string.
    #
    # Sending the string 'true' or 'false' seems to work for the unpublished
    # and include_allopen parameters, and feels more idiomatic Ruby-ish,
    # so we will use those values.
    VALID_SHIFTS_OPTIONS = [
      :location_id,
      :start,
      :end,
      :unpublished,
      :include_allopen
    ]
    def shifts(options)
      validate_options(VALID_SHIFTS_OPTIONS, options)

      parsed_response = wiwapi :get, 'shifts', options

      these_shifts = []
      for hash in parsed_response['shifts']
        new_object = Shift.new(self, hash)
        @shifts[new_object.id] = new_object
        these_shifts << new_object
      end
      return these_shifts
    end

    def get_shift(id)
      # see if it's in the cache
      return @shifts[id] if @shifts[id]
      parsed_response = wiwapi :get, "shifts/#{id}"
      @shifts[id] = Shift.new(self, parsed_response['shift'])
      return @shifts[id]      
    end

    def create_shift(attributes)
      parsed_response = wiwapi :post, 'shifts', NO_QUERY, attributes
      hash = parsed_response['shift']
      new_object = Shift.new(@connection, hash)
      @shifts[new_object.id] = new_object
      return new_object
    end

    def update_shift(id, attributes)
      object = get_shift(id)
      attributes.each do |k, v|
        raise WIWorkError, "#{k} is not a valid Shift attribute" unless object.respond_to? k
      end
      parsed_response = wiwapi :put, "shifts/#{id}", NO_QUERY, attributes
      @shifts[id] = Shift.new(self, parsed_response['shift'])
      return @shifts[id]
    end

    def publish_shifts(ids)
      ids = [ids] unless ids.respond_to? :each
      parsed_response = wiwapi :post, "shifts/publish", NO_QUERY, {ids: ids}
      if parsed_response['success'] == true
        for id in ids
          @shifts[id] = get_shift(id)
        end
      end
      return (parsed_response['success'] ? true : false)
    end

    def unpublish_shifts(ids)
      ids = [ids] unless ids.respond_to? :each
      parsed_response = wiwapi :post, "shifts/unpublish", NO_QUERY, {ids: ids}
      return (parsed_response['success'] ? true : false)
    end

    def delete_shift(id)
      parsed_response = wiwapi :delete, "shifts/#{id}"
      return (parsed_response['success'] ? true : false)
    end

  end
end