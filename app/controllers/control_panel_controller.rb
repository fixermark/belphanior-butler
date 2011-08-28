require 'json'

class ControlPanelController < ApplicationController
  def get_commands
    commands = CommandButton.find(:all)
    respond_with_json(commands)
  end

  def add_command
    new_command = CommandButton.new_from_json(request.raw_post)
    if not new_command.save
      respond_app_error("CommandSaveFailed")
    else
      respond_with_json(new_command)
    end
  end

  def update_command
    command_raw = request.raw_post
    command_data = JSON.parse(command_raw)
    command = CommandButton.find(command_data['id'])
    if not command
      return respond_app_error("UnknownCommand", 
        "Could not find command button with id #{command_data['id']}")
    end
    command.from_json(command_raw)
    if not command.save
      return respond_app_error("CommandSaveFailed", 
        "Could not save command button with id #{command_data['id']}")
    end
    respond_with_json command
  end

  def delete_command
    data = JSON.parse(request.raw_post)
    CommandButton.destroy(data["id"])
    respond_ok
  end
end
