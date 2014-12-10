class TestLocations < MiniTest::Unit::TestCase

  def test_shifts

    VCR.use_cassette('shifts') do

      @today = Date.today

      token = WhenIWork::Connection::TOKEN
      @connection = WhenIWork::Connection.new(token)

      # location is required for shift endpoints
      @location = @connection.locations.first

      # get all shifts for this location
      shifts = all_shifts

      # delete them all
      for shift in shifts
        @connection.delete_shift(shift.id)
      end
      # now there should be no shifts in that range
      shifts = all_shifts
      assert_equal 0, shifts.count

      # create some shifts
      fill_week_with_shifts(@location)
      shifts = all_shifts
      assert_equal 14, shifts.count      

      # test published/unpublished option
      shifts = all_published
      assert_equal 0, shifts.count

      # test sending bad options to Listing Shifts, should get an exception
      exception_thrown = false
      begin
        shifts = @connection.shifts({location_id: @location.id,
                                     start: @today - 365,
                                     end: @today + 365,
                                     invalid_option: true,
                                     unpublished: true,
                                     include_allopen: true})
      rescue WhenIWork::WIWorkError
        exception_thrown = true
      end
      assert_equal true, exception_thrown

      # publish a shift
      shifts = all_published_or_not
      # test publishing multiple shifts
      shifts_to_publish = shifts[1, 2].collect{|s| s.id} 
      @connection.publish_shifts(shifts_to_publish)
      # and just a single shift
      shift_to_publish = shifts[3].id
      @connection.publish_shifts(shift_to_publish)
      # now we should have 3 published shifts and 14 total (default
      # includes published)
      assert_equal 3, all_published.count
      assert_equal 14, all_published_or_not.count
      # unpublish that last one
      @connection.unpublish_shifts(shift_to_publish)
      assert_equal 2, all_published.count
      assert_equal 14, all_published_or_not.count

      # published shifts should be marked as such
      published_shift = @connection.get_shift(shifts_to_publish.first)
      assert_equal true, published_shift.published

    end

  end

  def fill_week_with_shifts(location)
    (0..6).each do |day_offset|
      day = @today + day_offset
      base_time = Time.new(day.year, day.month, day.day)
      [8, 13].each do |start_hour|
        start_time = base_time + (start_hour * 60 * 60)
        end_time = start_time + (4 * 60 * 60)
        shift_values = {
          location_id: location.id,
          start_time: start_time,
          end_time:   end_time,
          notes: "Shift #{day_offset}/#{start_hour}"
        }
        shift = @connection.create_shift(shift_values)
      end
    end
  end

  def shifts(unpublished=false, include_allopen=false)
    @connection.shifts({location_id: @location.id,
                        start: @today - 365,
                        end: @today + 365,
                        unpublished: unpublished,
                        include_allopen: include_allopen})
  end

  def all_shifts
    shifts(true, true)
  end

  def all_published
    shifts(false, true)
  end

  def all_published_or_not
    shifts(true, true)
  end

end
