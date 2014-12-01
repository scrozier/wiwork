module WhenIWork
  class Connection

    # because one can use the API to get a filtered list of shifts, we
    # always hit the API for this call; we *do* store the returned shifts,
    # even though they may not be a full set, because we can use them
    # to retrieve single shifts by id with get_shift
    def shifts(parameters)
      parsed_response = wiwapi :get, 'shifts', parameters
      these_shifts = []
      for hash in parsed_response['shifts']
        new_object = Shift.new(self, hash)
        @shifts[new_object.id] = new_object
        these_shifts << new_object
      end
      return these_shifts
    end

    def create_shift(attributes)
      parsed_response = wiwapi :post, 'shifts', NO_QUERY, attributes
      hash = parsed_response['shift']
      new_object = Shift.new(@connection, hash)
      @shifts[new_object.id] = new_object
      return new_object
    end

    def delete_shift(id)
      parsed_response = wiwapi :delete, "shifts/#{id}"
      return (parsed_response['success'] ? true : false)
    end

  end
end