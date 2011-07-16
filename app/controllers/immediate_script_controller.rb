require 'json'

class ImmediateScriptController < ApplicationController
  def index
    command_text = JSON.parse(request.raw_post)['command']
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
      response << e.to_str + "\n"
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
  end
end
