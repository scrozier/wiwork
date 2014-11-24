module WhenIWork

  class Connection
    
    def create_shift(location_id, start_time, end_time, notes)
      parsed_response = wiwapi :post, 'shifts',
        {location_id: location_id, start_time: start_time, end_time: end_time, notes: notes}
      shift = Shift.new(self, parsed_response['shift'])
      @shifts[shift.id] = shift
      return shift
    end

  end

end