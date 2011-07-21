require 'json'

class CommandButton < ActiveRecord::Base
  def from_json(json)
    json_hash = JSON.parse(json)
    self.name = json_hash['name']
    self.command = json_hash['command']
  end

  def self.new_from_json(json)
    result = self.new
    result.from_json(json)
    result
  end
end
