require 'reloader/message_sse'

class MessagesController < ApplicationController
  include ActionController::Live
#   respond_to :html, :js


  # GET /messages
  # GET /messages.json
  def index
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Reloader::MessageSSE.new(response.stream)

    begin

      last_id = 1

      loop do
#         Message.uncached do
          message = Message.uncached_find(last_id)
#         end
        if message.present?
          responce = message
          last_id = last_id + 1
          sse.write(responce, event: "refresh")
        else
#           responce = "No New Message at: #{Time.now}"
        end
#         responce = "No New Message at: #{Time.now}"
#         sse.write(responce)
#         sleep 1
      end

    rescue Exception, IOError, ActionDispatch::IllegalStateError
      # When the client disconnects, we'll get an IOError on write
      puts "Host hungup"
    ensure
      sse.close
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_path, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example: params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def message_params
      params.require(:message).permit(:body)
    end
end
