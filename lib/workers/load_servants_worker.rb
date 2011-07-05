require 'net/http'
require 'uri'

class LoadServantsWorkerException < Exception
end

class LoadServantsWorker < BackgrounDRb::MetaWorker
  set_worker_name :load_servants_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end

  def update_servants
    servants = Servant.find(:all)
    servants.each do |servant|
      begin
        if servant.status == :loading_protocol then
          load_protocol servant
        end
        if servant.status == :loading_roles then
          load_roles servant
        end
      rescue => e
        logger.error(e.message + "\n" + e.backtrace.join("\n")) 
      end
    end
  end

  def load_protocol(servant)
    begin
      servant.protocol = get_json(servant.url)
    rescue LoadServantsWorkerException => e
      servant.log_error(
        :could_not_load_protocol,
        "Error while loading protocol: " +
        e.to_str())
    end
    if not servant.save then
      # TODO(mtomczak): Figure out how to re-sanitize the
      # record and attempt to log its status
      logger.error("Servant named '" + servant.name +
                   "' failed to save when updating protocol.")
    end
  end
  
  def load_roles(servant)
    # Loads roles. Should not be called if servant.roles
    # is nil.
    roles = servant.roles
    role_urls = servant.role_urls
    roles.each_with_index do |role, index|
      if not role then
        load_role role_urls[index]
      end
    end
  end

  def load_role(role_url)
    # Updates the role database to include the role at
    # the specified URL. Returns the role if successful.
    # Raises LoadServantsWorkerException if unsuccessful.
    role_json = get_json(role_url)
    role = Role.new_from_json(role_json)
    role.url = role_url
    if not role.save then
      raise LoadServantsWorkerException, "Could not save role."
    end
    role
  end

  def get_json(at_url)
    # Retrieve JSON at a URL (as a URI).
    # Returns the resulting JSON, or raises an error.
    log = BackgrounDRb::DebugMaster.new(:foreground)
    log.info("Retrieving json at " + (at_url.to_s))
    source_url = at_url
    request = Net::HTTP::Get.new(source_url.path)
    response = Net::HTTP.start(source_url.host, source_url.port) {|http|
      http.request(request)
    }
    # validate status
    # TODO(mtomczak): Does net handle redirection?
    if response.code != "200" then
      raise LoadServantsWorkerException, (
                                          "While retrieving URL '" + at_url + 
                                          "', received response code of '" + response.code +
                                          "'.")
    else
      return response.body
    end
  end
end
