require 'json'
require 'uri'

class Role < ActiveRecord::Base
  def from_json(json)
    json_hash = JSON.parse(json)
    self.name = json_hash["name"]
    self.model = json
  end
  def url=(new_url)
    path = new_url.path
    port = new_url.port
    write_attribute(:url, new_url.to_s)
  end
  def url
    URI.parse(read_attribute(:url))
  end
    
  def self.new_from_json(json)
    result = self.new
    result.from_json(json)
    result
  end
end
