require 'json'
require 'uri'
require 'logger'
require 'uri'

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

  def url=(new_url)
    write_attribute(:url, new_url.to_s)
  end

  def url
    URI.parse(read_attribute(:url))
  end

  def status
    # Three statuses are loading_roles, loading_protocol, and loaded.
    if not self.protocol? then
      :loading_protocol
    else
      # TODO(mtomczak): It's possible an error could occur.
      #   If so, need an :error status (and code and human-
      #   readable form).
      roles = self.roles
      if not roles or roles.include? nil then
        :loading_roles
      else
        :loaded
      end
    end
  end

  def role_urls
    # Returns the URLs associated with the roles (as an
    # array), or nil if the protocol does not exist.
    # Any invalid role URLs are returned as nil.
    # Relative URLs are yielded as absolute URLs (with the
    # servant's URL as the absolute location).
    if not self.protocol? then
      return nil
    end
    begin
      protocol_object = JSON.parse(self.protocol)
      protocol_url = self.url
      if not protocol_object.has_key? "roles" then
        return nil
      end
      role_urls = protocol_object["roles"].map { |role_object|
        if not role_object.has_key? "role_url" then
          nil
        else
          role_url = URI.parse(role_object["role_url"])
          if not role_url.host then
            new_url = URI.parse(protocol_url.to_s)
            new_url.path = role_url.path
            role_url = new_url
          end
          role_url
        end
      }
      return role_urls
    rescue JSON::ParserError => e
      log_error(:could_not_parse_protocol,
                "The servant's protocol could not be " +
                "parsed.")
      return nil
    end
  end
  
  def roles
    # Returns the roles associated with this protocol
    # (as an array), or nil if the roles do not exist 
    # (or cannot be loaded).
    #
    # The returned array has a Role object for each role,
    # or nil if the role object is missing.
    #
    # Errors that occur in parsing JSON result in an error
    # being logged.
    urls = role_urls
    if not urls then
      return nil
    end
    urls.map { |url|
      if not url then
        nil
      else
        Role.find_by_url(url.to_s)
      end
    }
  end
  def log_error(status, err_msg)
    # TODO(mtomczak): Finish implementation of logging.
    #   Log should be stored on the DB object.
    logger.error("Error reported for servant with URL " +
                 self.url.to_s + ": " + err_msg)
  end
  def self.new_from_json(json)
    result = self.new
    result.from_json(json)
    result
  end
end
