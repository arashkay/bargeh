object @post
attributes :id, :body, :latitude, :longitude
node(:has_existed){ |o| o.has_existed? }
