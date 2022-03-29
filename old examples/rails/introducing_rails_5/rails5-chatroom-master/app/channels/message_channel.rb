class MessageChannel < ApplicationCable::Channel
  def subscribed
    reject unless approved
  end

  def follow(data)
    stream_from "room:#{data['room_id'].to_i}:messages"
  end

  def unfollow
    stop_all_streams
  end
end
