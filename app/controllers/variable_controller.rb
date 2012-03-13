require 'json'

class VariableController < ApplicationController
  def add
    new_variable = Variable.new_from_json(request.raw_post)
    if not new_variable.save
      respond_app_error("DuplicateRecord")
    else
      respond_with_json(:data => new_variable)
    end
  end

  def get
    variables = Variable.find(:all)
    respond_with_json(:data => variables)
  end

  def update
    data = JSON.parse(request.raw_post)
    variable = Variable.find_by_id(data["id"])
    if not variable
      respond_app_error("RecordNotFound")
    else
      variable.from_json(request.raw_post)
      if not variable.save
        respond_app_error("SaveFailed")
      else
        respond_ok
      end
    end
  end

  def delete
    data = JSON.parse(request.raw_post)
    variable_to_delete = Variable.delete_all(:id=>data["id"])
    respond_ok
  end
end
