# Controller for running scripts remotely.
class DoController < ApplicationController
  def index
    if request.method == 'GET' then
      respond_with_json({
        "name" => "commandable",
        "description" => "A generalized interface for servants that respond to dynamic commands.",
        "commands" => [{
          "name" => "do",
          "description" => "Do a specific command.",
          "arguments" => [{
            "name" => "command",
            "description" => "Name of command to execute."
          }],
          "returns" => "The result of the command, which has a command-dependent format."
        }]
      })
    elsif request.method == 'POST' then
      script_name = JSON.parse(request.raw_post)['script_name']
      script = Script.find_by_name(script_name)
      if not script:
          respond_app_error("Cannot find script by name '#{script_name}'.")
      else
        run_script_text script.command
      end
    else
      respond_app_error("Cannot handle specified HTTP method.")
    end
  end
end
