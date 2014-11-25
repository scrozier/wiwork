require_relative '../lib/wiwork'
require 'minitest/autorun'

class TestLocations < MiniTest::Unit::TestCase
  def test_deleting_and_adding_locations
    token = 'a822bf37a7c6597a2a0d5d1a83838aac31715a5f'
    connection = WhenIWork::Connection.new(token)
    assert_instance_of WhenIWork::Connection, connection
    locations = connection.locations
    assert_equal locations.count, 1
    for location in locations
      location.delete
    end
    locations = connection.locations
    assert_equal locations.count, 0
  end
end
