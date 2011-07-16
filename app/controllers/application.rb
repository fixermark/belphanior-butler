# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'belphanior/servant_caller'

class ScriptRunner
  class ServantLoadFailure < RuntimeError
  end
  class TellFailure < RuntimeError
  end
  def initialize
    @servants_by_name={}
  end

  def anonymous_script
    # Provide a context in which to run an anonymous script
    binding
  end
  
  def servant_by_name(name)
    if not @servants_by_name.has_key? name then
      cache_servant_caller(name)
    end
    @servants_by_name[name]
  end

  def tell(params)
    servant_name = params[:servant]
    servant_role = params[:role]
    
    servant = servant_by_name(servant_name)
    if not servant then
      raise ServantLoadFailure, "Servant with name '#{servant_name}' was nil."
    end
    
    yield servant.get_context_by_name(servant_role)
  end

 private
  def cache_servant_caller(name)
    servant = Servant.find_by_name(name)
    if not servant then
      raise ServantLoadFailure, "No servant with name '#{name}' found."
    end
    if servant.status != :loaded then
      raise ServantLoadFailure, "Servant '#{name}' is not loaded."
    end
    # TODO(mtomczak): We have a working servant; cache it.
    roles_by_url = {}
    role_urls = servant.role_urls
    role_urls.each do |url|
      role = Role.find_by_url(url.to_s)
      if role then
        roles_by_url[url.to_s]=JSON.parse(role.model)
      end
    end
    
    servant_caller = Belphanior::ServantCaller.new(
      RAILS_DEFAULT_LOGGER, 
      servant.url.to_s,
      JSON.parse(servant.protocol),
      roles_by_url)
    @servants_by_name[name]=servant_caller      
  end
end

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4b255128bb6ff0b74fbd1cd1035aa234'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def respond_ok
    response.content_type = "application/JSON"
    render :json => {"status" => "OK"}
  end
  def respond_with_json(data)
    response.content_type = "application/JSON"
    render :json => data
  end
  def respond_app_error(error_name)
    response.content_type = "application/JSON"
    render :status => 500, :json => {"name" => error_name}
  end
end
