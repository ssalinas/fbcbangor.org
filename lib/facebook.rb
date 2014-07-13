class Facebook
  def initialize
    @graph = Koala::Facebook::API.new(
      Rails.application.secrets.fb_token,
      Rails.application.secrets.fb_secret
    )
  end

  def facebook_feed
    data = @graph.get_connections(38163126787, "feed")
    data.each_with_object([]) do |post, formatted_data|
      if valid_picture(post)
        formatted_data << {
          user_image: "http://graph.facebook.com/#{post['from']['id']}/picture",
          user_name: post['from']['name'],
          img_src: post['picture'].gsub(/\/s\d{1,4}x\d{1,4}/, ''),
          link: post['link'],
          caption: post['caption'],
          type: :picture
        }
      elsif valid_status(post)
       formatted_data << {
          user_image: "http://graph.facebook.com/#{post['from']['id']}/picture",
          user_name: post['from']['name'],
          message: post['message'],
          comments: post['comments'] ? post['comments']['data'] : nil,
          type: :status
        }
      end
    end
  end

  def valid_picture(post)
    if post['type'] == 'photo'
      unless post['caption'] && post['caption'].match(/Attachment Unavailable/)
        true
      end
    end
  end

  def valid_status(post)
    if post['type'] == 'status' && !(post['message'].nil?)
      unless post['caption'] && post['caption'].match(/Attachment Unavailable/)
        true
      end
    end
  end
end
