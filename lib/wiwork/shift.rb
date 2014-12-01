module WhenIWork
  class Shift < WIWAPIObject

    attr_reader :id, :user_id, :location_id, :position_id, :site_id,
      :start_time, :end_time, :break_time, :color, :notes, :published,
      :notified_at, :created_at, :updated_at

    def self.date_time_attributes
      [:start_time, :end_time, :notified_at]
    end

  end
end
