require 'json'

class ImmediateScriptController < ApplicationController
  def index
    data = JSON.parse(request.raw_post)
    run_script_text(data['command'], data['format'])
  end
end
