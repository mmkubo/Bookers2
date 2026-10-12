class RoomsController < ApplicationController
  before_action :set_room, only: [:show]
  before_action :ensure_room_member, only: [:show]

  def create
    other_user = User.find(params[:other_id])
    common_room = (Current.user.rooms & other_user.rooms).first

    if common_room
      redirect_to common_room
    else
      room = Room.create
      Entry.create(user_id: Current.user.id, room_id: room.id)
      Entry.create(user_id: other_user.id, room_id: room.id)
      redirect_to room
    end
  end

  def show
    @messages = @room.messages
    @message = Message.new
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def ensure_room_member
    unless @room.users.include?(Current.user)
    redirect_to user_path(Current.user.id)
    end
  end
end

