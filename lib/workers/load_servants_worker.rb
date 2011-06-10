require 'net/http'
require 'uri'

class LoadServantsWorker < BackgrounDRb::MetaWorker
  set_worker_name :load_servants_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end

  def update_servants
    logger.info "Updating servants..."
    servants = Servant.find(:all)
    servants.each do |servant|
      if servant.status == :loading_protocol then
        load_protocol servant
      end
    end
  end

  def load_protocol(servant)
    begin
      source_url = URI.parse(servant.url)
      request = Net::HTTP::Get.new(source_url.path)
      response = Net::HTTP.start(source_url.host, source_url.port) {|http|
        http.request(request)
      }
      # validate status
      # TODO(mtomczak): Does net handle redirection?
      if response.code != "200" then
        servant.log_error(:could_not_retrieve_protocol,
                          "When retrieving the protocol from '" +
                          servant.url +
                          "', protocol server reported code " +
                          response.code + 
                          " instead of 200.")
      else
        servant.protocol = response.body
      end
    rescue URI::InvalidURIError => e
      servant.log_error(:could_not_parse_url,
                        "The servant's URL of '" +
                        servant.url + 
                        "' could not be parsed.")
    end
    if not servant.save then
      # TODO(mtomczak): Figure out how to re-sanitize the
      # record and attempt to log its status
      logger.error("Servant named '" + servant.name +
                   "' failed to save when updating protocol.")
    end
  end
end
