class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
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
end
