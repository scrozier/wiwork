require_relative '../lib/wiwork'
require 'minitest/autorun'

class TestLocations < MiniTest::Unit::TestCase

  def setup
    @token = 'a822bf37a7c6597a2a0d5d1a83838aac31715a5f'
  end

  def test_locations

    connection = WhenIWork::Connection.new(@token)

    # reset to a known starting point
    locations = connection.locations
    for location in locations
      break if connection.locations.count == 1
      connection.delete_location(location.id)
    end
    assert_equal connection.locations.count, 1
    headquarters_id = connection.locations.first.id

    headquarters_latitude = 32.829001
    headquarters_longitude = -96.748154
    location = connection.update_location(headquarters_id,
      name: 'New York Headquarters (Empire State Building)',
      address: '350 5th Ave, New York, NY 10118',
      coordinates: [headquarters_latitude, headquarters_longitude]
      )

    new_location_values = {
      name: 'Government Operations',
      address: '1600 Pennsylvania Ave NW, Washington, DC 20500'
    }
    new_location = connection.create_location(new_location_values)
    assert_equal connection.locations.count, 2
    assert_equal new_location.name, new_location_values[:name]

    location = connection.get_location(new_location.id)
    assert_equal location.name, new_location.name

    # start a new connection and get a specific location
    connection = WhenIWork::Connection.new(@token)
    location = connection.get_location(location.id)
    assert_equal new_location_values[:name], location.name

    # check coordinates - CURRENTLY NOT WORKING, SEE WhenIWork Request #32387
    # location = connection.get_location(headquarters_id)
    # assert_equal headquarters_latitude, location.coordinates.first
    # assert_equal headquarters_longitude, location.coordinates.last

    # update the values
    new_name = 'Religious Operations'
    new_address = '3101 Wisconsin Ave NW, Washington, DC 20016'
    location = connection.update_location(location.id, name: new_name, address: new_address)
    assert_equal 2, connection.locations.count # we haven't added or deleted any
    assert_equal new_name, location.name
    assert_equal new_address, location.address

  end

end
