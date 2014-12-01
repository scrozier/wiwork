module WhenIWork
  class Location < WIWAPIObject

    attr_reader :id, :name, :address, :coordinates, :created_at, :updated_at

    def self.date_time_attributes
      []
    end

  end
end
