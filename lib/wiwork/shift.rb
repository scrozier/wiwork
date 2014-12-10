module WhenIWork
  class Shift < WIWAPIObject

    readable_attributes = [:id, :user_id, :location_id, :position_id, :site_id,
      :start_time, :end_time, :break_time, :color, :notes, :published,
      :notified_at, :created_at, :updated_at]

    attr_reader *readable_attributes

    def self.date_time_attributes
      [:start_time, :end_time, :notified_at]
    end

  end
end
