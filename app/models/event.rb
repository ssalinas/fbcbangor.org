  class Event < ActiveRecord::Base
    attr_accessor :period, :frequency, :commit_button

    validates :title, :description, :presence => true
    validate :validate_timings

    belongs_to :event_series

    REPEATS = {
      :no_repeat => "Does not repeat",
      :days      => "Daily",
      :weeks     => "Weekly",
      :months    => "Monthly",
      :years     => "Yearly"
    }

    def validate_timings
      if (starttime >= endtime) and !all_day
        errors[:base] << "Start Time must be less than End Time"
      end
    end

    def update_events(events, event)
      events.each do |e|
        begin
          old_start_time, old_end_time = e.starttime, e.endtime
          e.attributes = event
          if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
            new_start_time = make_date_time(e.starttime, old_start_time)
            new_end_time   = make_date_time(e.starttime, old_end_time, e.endtime)
          else
            new_start_time = make_date_time(e.starttime, old_end_time)
            new_end_time   = make_date_time(e.endtime, old_end_time)
          end
        rescue
          new_start_time = new_end_time = nil
        end
        if new_start_time and new_end_time
          e.starttime, e.endtime = new_start_time, new_end_time
          e.save
        end
      end

      event_series.attributes = event
      event_series.save
    end

    def self.event_json_data(start_time, end_time)
      events = Event.where('
                  (starttime >= :start_time and endtime <= :end_time) or
                  (starttime >= :start_time and endtime > :end_time and starttime <= :end_time) or
                  (starttime <= :start_time and endtime >= :start_time and endtime <= :end_time) or
                  (starttime <= :start_time and endtime > :end_time)',
                  start_time: start_time, end_time: end_time)
      event_data = []
      events.each do |event|
        event_data << {
          id: event.id,
          title: event.title,
          description: event.description || '',
          start: event.starttime.iso8601,
          end: event.endtime.iso8601,
          allDay: event.all_day,
          recurring: (event.event_series_id) ? true : false
        }
      end
      event_data.to_json
    end

  private

    def make_date_time(original_time, difference_time, event_time = nil)
      DateTime.parse("#{original_time.hour}:#{original_time.min}:#{original_time.sec}, #{event_time.try(:day) || difference_time.day}-#{difference_time.month}-#{difference_time.year}")
    end
  end
