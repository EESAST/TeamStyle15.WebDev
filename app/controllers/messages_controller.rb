class MessagesController < ApplicationController
  skip_before_filter :admin_authorize, only: [:destroy, :delete]
  before_action :set_message, only: [:destroy,:delete]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  def delete
    if @message.read
      redirect_to :back,:notice=>'该消息已读'
    else
      @message.update(:read=>true)
      redirect_to :back,:notice=>'忽略成功'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:user_id, :type, :content, :read, :text)
    end
end
