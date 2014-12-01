class TestLocations < MiniTest::Unit::TestCase

  def test_shifts

    VCR.use_cassette('shifts') do

      @today = Time.new(Time.now.year, Time.now.month, Time.now.day)
      @one_hour = 60 * 60
      @one_day = @one_hour * 24
      @tomorrow = @today + @one_day
      @one_week = @one_day * 7

      token = WhenIWork::Connection::TOKEN
      @connection = WhenIWork::Connection.new(token)

      # location is required for shift endpoints
      location = @connection.locations.first

      # get all shifts for the next week
      shifts = @connection.shifts({start: @today, end: @today + @one_week, location_id: location.id})
      # delete them all
      for shift in shifts
        @connection.delete_shift(shift.id)
      end
      # now there should be no shifts in that range
      shifts = @connection.shifts({start: @today, end: @today + @one_week, location_id: location.id})
      assert_equal 0, shifts.count

      # create some shifts
      fill_week_with_shifts(location)
      shifts = @connection.shifts({start: @today, end: @today + @one_week, location_id: location.id})
      assert_equal 14, shifts.count      

    end

  end

  def fill_week_with_shifts(location)
    (0..6).each do |day_offset|
      [8, 13].each do |start_time|
        shift_values = {
          location_id: location.id,
          start_time: @today + (day_offset * @one_day) + (start_time * @one_hour),
          end_time:   @today + (day_offset * @one_day) + ((start_time + 4) * @one_hour),
          notes: "Shift #{day_offset}/#{start_time}"
        }
        shift = @connection.create_shift(shift_values)
      end
    end
  end

end
