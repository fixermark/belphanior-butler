require 'json'

class Servant < ActiveRecord::Base
  validates_uniqueness_of :name
  def to_json(*a)
    {
      'name' => self.name,
      'url' => self.url,
      'protocol' => self.protocol,
      'status' => self.status
    }.to_json(*a)
  end
  def from_json(json)
    json_hash = JSON.parse(json)
    self.name = json_hash['name']
    self.url = json_hash['url']
    if json_hash.has_key?('protocol') then
      self.protocol = json_hash['protocol']
    end
  end
  def status
    if self.protocol? then
      # TODO(mtomczak): Determine if all of the roles are
      # loaded. Remember, there may be multiple.
      :loading_roles
    else
      :loading_protocol
    end
  end
  def self.new_from_json(json)
    result = self.new
    result.from_json(json)
    result
  end
end
