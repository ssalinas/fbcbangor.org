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
      case post['type']
      when 'photo'
        valid_photo_post(post) ? formatted_data << photo_post(post) : nil
      when 'status'
        valid_status_post(post) ? formatted_data << status_post(post) : nil
      when 'link'
        valid_link_post(post) ? formatted_data << link_post(post) : nil
      end
    end
  end

  def valid_photo_post(post)
    unless post['caption'] && post['caption'].match(/Attachment Unavailable/)
      true
    end
  end

  def photo_post(post)
    {
      user_image: "http://graph.facebook.com/#{post['from']['id']}/picture",
      user_name: post['from']['name'],
      img_src: post['picture'] ? post['picture'].gsub(/\/s\d{1,4}x\d{1,4}/, '') : '',
      link: post['link'],
      caption: post['caption'],
      type: :photo
    }
  end

  def valid_status_post(post)
    if !(post['message'].nil?)
      unless post['caption'] && post['caption'].match(/Attachment Unavailable/)
        true
      end
    end
  end

  def status_post(post)
    {
      user_image: "http://graph.facebook.com/#{post['from']['id']}/picture",
      user_name: post['from']['name'],
      message: post['message'],
      comments: post['comments'] ? post['comments']['data'] : nil,
      type: :status
    }
  end

  def valid_link_post(post)
    unless post['message'] && post['message'].match(/Attachment Unavailable/)
      true
    end
  end

  def link_post(post)
    {
      user_image: post['from']['id'] ? "http://graph.facebook.com/#{post['from']['id']}/picture" : '',
      user_name: post['from']['name'] ? post['from']['name'] : '',
      img_src: post['picture'] ? post['picture'].gsub(/\/s\d{1,4}x\d{1,4}/, '') : '',
      link: post['link'],
      caption: post['message'],
      type: :link
    }
  end
end
