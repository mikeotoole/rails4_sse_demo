require 'reloader/message_sse'

class StreamsController < ApplicationController
  respond_to :js

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
        message = Message.uncached_find(last_id)
        if message.present?
          last_id = last_id + 1
          sse.write(message, event: "refresh")
        end
      end
    rescue Exception, IOError, ActionDispatch::IllegalStateError
      # When the client disconnects, we'll get an IOError on write
      puts "Host hungup"
    ensure
      sse.close
    end
  end
end
