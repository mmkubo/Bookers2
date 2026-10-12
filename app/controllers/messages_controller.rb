class MessagesController < ApplicationController
  before_action :set_room, only: [:create]
  before_action :ensure_room_member, only: [:create]
  def create
    @message = Message.new(message_params)
    @message.user_id = Current.user.id
    @message.room_id = @room.id
    if @message.save
      redirect_to @room
    else
      @messages = @room.messages
      render "rooms/show", status: :unprocessable_entity
    end
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def ensure_room_member
    unless @room.users.include?(Current.user)
      redirect_to user_path(Current.user.id)
    end
  end

end

