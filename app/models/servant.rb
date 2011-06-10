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
    # Three statuses are loading_roles, loading_protocol, and loaded.
    if self.protocol? then
      # TODO(mtomczak): Determine if all of the roles are
      #   loaded. Remember, there may be multiple.
      # TODO(mtomczak): It's possible an error could occur.
      #   If so, need an :error status (and code and human-
      #   readable form).
      :loading_roles
    else
      :loading_protocol
    end
  end
  
  def log_error(status, err_msg)
    # TODO(mtomczak): Finish implementation of logging.
    #   Log should be stored on the DB object.
    logger.error("Error reported for servant with URL " +
                 self.url + ": " + err_msg)
  end
  def self.new_from_json(json)
    result = self.new
    result.from_json(json)
    result
  end
end
