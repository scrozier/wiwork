class TestLocations < MiniTest::Unit::TestCase

  def test_locations

    VCR.use_cassette('locations') do

      token = WhenIWork::Connection::TOKEN
      connection = WhenIWork::Connection.new(token)

      # reset to a single location
      locations = connection.locations
      for location in locations
        break if connection.locations.count == 1
        connection.delete_location(location.id)
      end
      assert_equal connection.locations.count, 1
      headquarters_id = connection.locations.first.id

      # set that location to a known set of attributes
      headquarters_latitude = 32.829001
      headquarters_longitude = -96.748154
      headquarters = connection.update_location(headquarters_id,
        name: 'New York Headquarters (Empire State Building)',
        address: '350 5th Ave, New York, NY 10118',
        coordinates: [headquarters_latitude, headquarters_longitude]
        )

      # create a new location
      southeast_values = {
        name: 'Southeast Operations',
        address: '1 Lodge St, Asheville, NC 28803'
      }
      southeast = connection.create_location(southeast_values)
      # should be 2 locations in the list now
      assert_equal 2, connection.locations.count
      # the attributes should be as we set them
      assert_equal southeast_values[:name], southeast.name
      assert_equal southeast_values[:address], southeast.address

      # start a new connection and get a specific location, to be sure
      # it got persisted at WhenIWork, not just in our cache
      connection = WhenIWork::Connection.new(token)
      location = connection.get_location(southeast.id)
      assert_equal southeast_values[:name], location.name
      southeast = location

      # check coordinates - CURRENTLY NOT WORKING, SEE WhenIWork Request #32387
      # location = connection.get_location(headquarters_id)
      # assert_equal headquarters_latitude, location.coordinates.first
      # assert_equal headquarters_longitude, location.coordinates.last

      # move this location to the west (test update_location)
      western_values = {
        name: 'Western Operations',
        address: '1500 Orange Ave, Coronado, CA 92118'
      }
      western = connection.update_location(southeast.id, western_values)
      # still should have 2 locations
      assert_equal 2, connection.locations.count
      # and update should change the attributes
      assert_equal western_values[:name], western.name
      assert_equal western_values[:address], western.address

      # try to get a non-existent location, first from cache...
      location = connection.get_location(0)
      assert_equal nil, location

      # ...then by forcing an API hit
      connection = WhenIWork::Connection.new(token)
      location = connection.get_location(0)
      assert_equal nil, location

      # test delete_location
      location = connection.delete_location(western.id)
      # should be down to 1 location
      assert_equal 1, connection.locations.count
      # force an API hit and verify 1 location
      connection = WhenIWork::Connection.new(token)
      assert_equal 1, connection.locations.count

    end

  end

end
