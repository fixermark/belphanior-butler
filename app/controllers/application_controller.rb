# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'rubygems'
require 'belphanior/servant_caller'
require 'blockly/xml_parser'
require 'blockly/context'

class VariableAdaptor
  # Adapts reads / writes to variable store as
  # gets / sets on a singleton object.
  class VariableDoesNotExistError < RuntimeError
  end

  def [] (name)
    requested_variable = Variable.find_by_name(name)
    if not requested_variable then
      raise VariableDoesNotExistError, "No variable by name '#{name}'"
    end
    requested_variable.value
  end

  def []=(name, value)
    requested_variable = Variable.find_or_create_by_name(name)
    requested_variable.value = value
    requested_variable.save
  end
end

class ScriptAdaptor
  # Adapts reads on a script store as gets on the script database.
  class ScriptDoesNotExistError < RuntimeError
  end

  def [](name)
    requested_script = Script.find_by_name(name)
    if not requested_script then
      raise ScriptDoesNotExistError, "No script by name '#{name}'"
    end
    if requested_script.format == "ruby"
      # Need to return a callable; compile that script!
      runner = ScriptRunner.new
      Proc.new {
        eval(
          requested_script.command,
          runner.anonymous_script,
          requested_script.name, 1)
      }
    else  # Blockly!
      parser = Blockly::Xml::Parser.new
      code = parser.parse(requested_script.command)
      context = Blockly::Context.new
      Proc.new {
        code.evaluate(context)
        context.stdout
      }
    end
  end

  def call(name)
    self[name].call
  end
end

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
    variables = VariableAdaptor.new
    scripts = ScriptAdaptor.new
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

  def servants_by_role()
  # Retrieves all servants and yields a hash from role URI toservant
  # name list.
    role_uris = {}
    Servant.all.each do |servant|
      role_urls = servant.role_urls
      if role_urls != nil
        role_urls.each do |url|
          if url != nil
            url_s = url.to_s
            if role_uris.has_key? url_s
              role_uris[url_s] << servant.name
            else
              role_uris[url_s] = [servant.name]
            end
          end
        end
      end
    end
    role_uris
  end

  def call_servant_role_uri_command(
      servant_name,
      role_uri,
      command_name,
      args)
    caller_hash = servant_by_name(servant_name).callers_by_role_url_and_name
    caller_hash[role_uri][command_name].call(args)
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
      Rails.logger,
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
  def respond_app_error(error_name, message=nil)
    response.content_type = "application/JSON"
    response = {"name" => error_name}
    if message
      response["message"] = message
    end
    render :status => 500, :json => response
  end

  def run_script_text(command_text, script_format)
    if script_format == "blockly" then
      run_blockly_script command_text
    else
      run_ruby_script command_text
    end
  end

  def run_blockly_script(blockly_xml)
    parser = Blockly::Xml::Parser.new
    code = parser.parse(blockly_xml)
    context = Blockly::Context.new
    code.evaluate(context)
    respond_with_json(:response => (context.stdout))
  end

  def run_ruby_script(command_text)
    runner = ScriptRunner.new
    begin
      respond_with_json(
        :response => eval(
          command_text,
          runner.anonymous_script,
          "<Immediate script>",
          1))
    rescue Exception => e
      response = "Evaluation failed: An error occurred.\n"
      response << e.to_str() << "\n"
      # Trim the stack trace at the immediate script entrypoint... no
      # need to trace into the Butler framework.
      seen_immediate_script = false
      e.backtrace.each do |err_line|
        if err_line.start_with? "<Immediate script>" then
          seen_immediate_script = true
        else
          if seen_immediate_script then
            break
          end
        end
        response << err_line + "\n"
      end
      respond_with_json(:response => response)
    end

    # Runs a Rails script
  end
end
