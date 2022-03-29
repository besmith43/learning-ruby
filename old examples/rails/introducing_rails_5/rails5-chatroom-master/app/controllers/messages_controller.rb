class MessagesController < ApplicationController
  def create
    message = Message.new(message_params).save
    redirect_back fallback_location: root_path
  end

  private

  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id, room_id: current_room.id)
  end
end
