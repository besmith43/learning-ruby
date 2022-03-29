class RoomsController < ApplicationController
  before_action :rooms

  def index
  end

  def show
    set_current_room
    @messages = room.messages
  end

  private

  def set_current_room
    session[:current_room] = params[:id] if params[:id]
  end

  def rooms
    @rooms ||= Room.all
  end

  def room
    @room ||= Room.find(params[:id])
  end
end
