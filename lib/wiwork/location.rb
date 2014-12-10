module WhenIWork
  class Location < WIWAPIObject

    readable_attributes = [:id, :name, :address, :coordinates, :created_at, :updated_at]

    attr_reader *readable_attributes

    def self.date_time_attributes
      []
    end

  end
end
