class Message < ActiveRecord::Base
def self.uncached_find(content_id)
  uncached do
    find_by_id(content_id)
  end
end
end
