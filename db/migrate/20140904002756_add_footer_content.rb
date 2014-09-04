class AddFooterContent < ActiveRecord::Migration
  def self.up
    Content.create(page: 'home', section: 'footer_1', content: "<p>First Baptist of Bangor</p>\n<p>56 Center Street</p>\n<p>Bangor, ME, 04401</p>\n<p>(207) 945 - 9694</p>")
    Content.create(page: 'home', section: 'footer_2', content: "<p>Weekly Services</p>\n<p>Sunday 10:15 AM</p>")
    Content.create(page: 'home', section: 'footer_3', content: "<img alt='abcom.jpg' src='/assets/abcom.jpg'/>")
    Content.create(page: 'home', section: 'footer_4', content: "<img alt='abcusa.gif' src='/assets/abcusa.gif'/>")
    Content.create(page: 'home', section: 'footer_5', content: "<img alt='kupenda.jpg' src='/assets/kupenda.jpg'/>")
  end
end
