require_relative '../lib/wiwork'
require 'minitest/autorun'

class TestLocations < MiniTest::Unit::TestCase

  def setup
    token = 'a822bf37a7c6597a2a0d5d1a83838aac31715a5f'
    @connection = WhenIWork::Connection.new(token)
  end

  def test_deleting_and_adding_locations

    locations = @connection.locations
    for location in locations
      break if @connection.locations.count == 1
      location.delete
    end
    assert_equal @connection.locations.count, 1

    new_location_values = {
      name: 'The Cedars',
      address: '1326 S Lamar St, Dallas, TX 75215'
    }
    new_location = WhenIWork::Location.create(@connection, new_location_values)
    assert_equal @connection.locations.count, 2
    assert_equal new_location.name, new_location_values[:name]

  end

end
