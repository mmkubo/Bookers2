class RoomsController < ApplicationController

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
end
