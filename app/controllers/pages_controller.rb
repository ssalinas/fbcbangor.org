class PagesController < ApplicationController

  def home
    @facebook_posts = Facebook.new.facebook_feed
    @announcements = Announcement.order(updated_at: :desc).first(3)
    @carousel_images = CarouselImage.all
    @image = Content.where(page: 'home', section: 'image').first.content
    @slogan = Content.where(page: 'home', section: 'slogan').first.content
    @footer_left = Content.where(page: 'home', section: 'footer_left').first.content
    @footer_right = Content.where(page: 'home', section: 'footer_right').first.content
    set_fullcalendar_options
  end

  def about
    @contents = Array(Content.where(page: 'about')) || []
  end

  def directions
    @location = {
      latitude: '44.8056244',
      longitude: '-68.7709881'
    }
    @address = Content.where(page: 'find_us', section: 'address').first.content
  end

  def contact
    @phone = Content.where(page: 'contact', section: 'phone').first.content
    @office = Content.where(page: 'contact', section: 'office').first.content
    @email = Content.where(page: 'contact', section: 'email').first.content
  end

  private

  def set_fullcalendar_options
    Fullcalendar::Configuration['editable'] = false
    Fullcalendar::Configuration['disableDragging'] = true
    gon.full_calendar_options = Fullcalendar::Configuration
  end
end
