require_relative '../lib/wiwork'
require 'minitest/autorun'

class TestLocations < MiniTest::Unit::TestCase

  def setup
    @token = 'a822bf37a7c6597a2a0d5d1a83838aac31715a5f'
    @connection = WhenIWork::Connection.new(@token)
  end

  def test_deleting_and_adding_locations

    locations = @connection.locations
    for location in locations
      break if @connection.locations.count == 1
      @connection.delete_location(location.id)
    end
    assert_equal @connection.locations.count, 1

    new_location_values = {
      name: 'The Cedars Social',
      address: '1326 S Lamar St, Dallas, TX 75215'
    }
    new_location = @connection.create_location(new_location_values)
    assert_equal @connection.locations.count, 2
    assert_equal new_location.name, new_location_values[:name]

    location = @connection.get_location(new_location.id)
    assert_equal location.name, new_location.name

    # start a new connection and get a specific location
    @connection = WhenIWork::Connection.new(@token)
    location = @connection.get_location(location.id)
    assert_equal location.name, new_location_values[:name]

    new_address = '6333 E Mockingbird Ln, Dallas, TX 75214'
    location = @connection.update_location(location.id, address: new_address)
    assert_equal @connection.locations.count, 2 # we haven't added or deleted any
    assert_equal location.address, new_address

  end

end
