class AddContent < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.integer :priority
    end
    Content.create(page: 'about', section: 'Welcome', content: "The mission of First Baptist Church is best represented by the following priorities: a strong, Biblically based, preaching ministry which communicates Christian theology in terms that are relevant to people's lives; a youth ministry which nurtures faith, commitment and discipleship; active programs of pastoral care, visitation, music, and involvement with members of the congregation; a ministry that leads people to make decisions for Christ and encourages their participation in the local church, community, and the world; a program of short-term Christian counseling; and a church environment which nurtures a sense of acceptance, inclusion, and caring. Our facilities are handicapped accessible.", image_src: 'church.jpg', priority: 1)
    Content.create(page: 'about', section: 'Our Pastor', content: "The Rev. Stephanie A. Salinas is a graduate of New Brunswick Theological Seminary in New Brunswick, New Jersey. She and her husband and two sons united with us in August of 2002. Rev. Salinas is an enthusiastic preacher, a dedicated teacher, and a compassionate counselor. She is dedicated to mission locally and globally.", image_src: 'pastor_stepahnie.jpg', priority: 2)
    Content.create(page: 'about', section: 'Worship and Music', content: "Worship services include not only solid biblical preaching, but choirs, musicals, holiday cantatas, and Youth Sundays. At First Baptist, music is an integral part of our worship service, and the Music Director works closely with the Music and Worship Committees. Opportunities for participation in the music program abound: Adult, Youth, Junior, and Cherub Choirs, as well as Hand Bell and Chime Choirs are regular blessings in our service. Our congregation is home to many gifted musicians of many ages.", image_src: 'youthchoir.jpg', priority: 3)
    Content.create(page: 'about', section: 'Missions', content: "Our church is very active in mission work, and many mission trips have been made to the Dominican Republic. One of the newer missions of our church, Operation Christmas Child, was very popular with many age groups during the Christmas season. We also recently sent a team to Tanzania as part of a mission with Kupenda for the Children. Locally, many members of First Baptist take part in the Dorothy Day Soup Kitchen, Habitat for Humanity, and more. In fact, it was a group from First Baptist Church that initiated the Habitat for Humanity of Greater Bangor.", image_src: 'tanzania.jpg', priority: 4)
    Content.create(page: 'contact', section: 'phone', content: '(207) - 945 - 9694')
    Content.create(page: 'contact', section: 'office', content: "<p>56 Center Street</p>\n<p>Bangor, ME 04401</p>\n<p>Office Hours are from 9am to 12pm Monday to Friday</p>")
    Content.create(page: 'contact', section: 'email', content: 'churchoffice@fbcbangor.org')
    Content.create(page: 'home', section: 'image', content: 'church_logo.png')
    Content.create(page: 'home', section: 'slogan', content: "We are a church family where God's grace and unconditional love guide us to provide a spiritual home for faith, worship, mission, and fellowship. We celebrate the dignity of each person's journey with Jesus Christ")
    Content.create(page: 'home', section: 'footer_left', content: "<p>First Baptist of Bangor</p>\n<p>56 Center Street</p>\n<p>Bangor, ME, 04401</p>\n<p>(207) 945 - 9694</p>")
    Content.create(page: 'home', section: 'footer_right', content: "<p>Weekly Services</p>\n<p>Sunday 10:15 AM</p>")
    Content.create(page: 'find_us', section: 'address', content: '56 Center Street - Bangor, ME 04401')
  end
end
