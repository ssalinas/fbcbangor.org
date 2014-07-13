class PagesController < ApplicationController

  def home
    @facebook_posts = Facebook.new.facebook_feed
    @announcements = Announcement.order('updated_at').last(3)
    set_fullcalendar_options
  end

  def about

  end

  def directions
    @location = {
      latitude: '44.8056244',
      longitude: '-68.7709881'
    }
  end

  def contact
  end

  private

  def set_fullcalendar_options
    Fullcalendar::Configuration['editable'] = false
    Fullcalendar::Configuration['disableDragging'] = true
    gon.full_calendar_options = Fullcalendar::Configuration
  end
end
