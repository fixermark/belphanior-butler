class ImmediateScriptController < ApplicationController
  def index
    render :text=>'{"response" : "Hello, world!"}'
  end
end
