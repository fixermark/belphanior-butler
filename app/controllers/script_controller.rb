class ScriptController < ApplicationController
  def add
    new_script = Script.new_from_json(request.raw_post)
    new_script.format = 'ruby'
    if not new_script.save
      respond_app_error("DuplicateRecord")
    else
      respond_with_json(:data => new_script)
    end
  end

  def get
    scripts = Script.where(:format => 'ruby')
    respond_with_json(:data => scripts)
  end

  def update
    data = JSON.parse(request.raw_post)
    script = Script.find_by_id(data["id"])
    if not script
      respond_app_error("RecordNotFound")
    elsif script.format != 'ruby'
      respond_app_error("RecordNotRubyScript")
    else
      script.from_json(request.raw_post)
      if not script.save!
        respond_app_error("SaveFailed")
      else
        respond_ok
      end
    end
  end

  def delete
    data = JSON.parse(request.raw_post)
    script_to_delete = Script.delete_all(:id=>data["id"])
    respond_ok
  end
end
