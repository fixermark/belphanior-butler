require 'json'

class ImmediateScriptController < ApplicationController
  def index
    command_text = JSON.parse(request.raw_post)['command']
    run_script_text command_text
  end
end
