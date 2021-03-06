  class EventsController < ApplicationController
    before_filter :load_event, only: [:edit, :update, :destroy, :move, :resize]
    before_filter :determine_event_type, only: :create

    layout :layout_from_user

    def index
      set_fullcalendar_options
    end

    def create
      if @event.save
        render nothing: true
      else
        render text: @event.errors.full_messages.to_sentence, status: 422
      end
    end

    def new
      respond_to do |format|
        format.js
      end
    end

    def get_events
      start_time = Time.at(params[:start].to_i).to_formatted_s(:db)
      gon.startDate = start_time
      end_time   = Time.at(params[:end].to_i).to_formatted_s(:db)
      render json: Event.event_json_data(start_time, end_time)
    end

    def move
      if @event
        @event.starttime = make_time_from_minute_and_day_delta(@event.starttime)
        @event.endtime   = make_time_from_minute_and_day_delta(@event.endtime)
        @event.all_day   = params[:all_day]
        @event.save
      end
      render nothing: true
    end

    def resize
      if @event
        @event.endtime = make_time_from_minute_and_day_delta(@event.endtime)
        @event.save
      end
      render nothing: true
    end

    def edit
      render json: { form: render_to_string(partial: 'edit_form') }
    end

    def update
      case params[:event][:commit_button]
      when 'Update All Occurrence'
        @events = @event.event_series.events
        @event.update_events(@events, event_params)
      when 'Update All Following Occurrence'
        @events = @event.event_series.events.where('starttime > :start_time',
                                                   start_time: @event.starttime.to_formatted_s(:db)).to_a
        @event.update_events(@events, event_params)
      else
        @event.attributes = event_params
        @event.save
      end
      render nothing: true
    end

    def destroy
      case params[:delete_all]
      when 'true'
        @event.event_series.destroy
      when 'future'
        @events = @event.event_series.events.where('starttime > :start_time',
                                                   start_time: @event.starttime.to_formatted_s(:db)).to_a
        @event.event_series.events.delete(@events)
      else
        @event.destroy
      end
      render nothing: true
    end

    private

    def load_event
      @event = Event.where(:id => params[:id]).first
      unless @event
        render json: { message: "Event Not Found.."}, status: 404 and return
      end
    end

    def event_params
      params.require(:event).permit('title', 'description', 'starttime', 'endtime', 'all_day', 'period', 'frequency', 'commit_button')
    end

    def determine_event_type
      if params[:event][:period] == "Does not repeat"
        @event = Event.new(event_params)
      else
        @event = EventSeries.new(event_params)
      end
    end

    def set_fullcalendar_options
      if user_signed_in?
        @can_edit = true
        Fullcalendar::Configuration['editable'] = true
        Fullcalendar::Configuration['disableDragging'] = false
      else
        @can_edit = false
        Fullcalendar::Configuration['editable'] = false
        Fullcalendar::Configuration['disableDragging'] = true
      end
      gon.full_calendar_options = Fullcalendar::Configuration
    end

    def layout_from_user
      if user_signed_in?
        'admin'
      else
        'application'
      end
    end

    def make_time_from_minute_and_day_delta(event_time)
      params[:minute_delta].to_i.minutes.from_now((params[:day_delta].to_i).days.from_now(event_time))
    end
  end
