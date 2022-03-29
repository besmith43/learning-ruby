class MessageRelayJob < ApplicationJob
  def perform(message)
    @message = message
    ActionCable.server.broadcast(room, message: shared_message)
  end

  private

  def room
    "room:#{@message.room.id}:messages"
  end

  def shared_message
    MessagesController.render(partial: 'shared/message', locals: {msg: @message})
  end
end
