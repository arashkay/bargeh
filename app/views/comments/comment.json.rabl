object @comment
attributes :id, :body, :user_id
node(:time_ago) { |m| distance_of_time_in_words(m.created_at, Time.now) }
