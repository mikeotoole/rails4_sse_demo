require 'reloader/message_sse'

class StreamsController < ApplicationController
  include ActionController::Live
  # GET /stream
  # GET /stream/.json
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
end
