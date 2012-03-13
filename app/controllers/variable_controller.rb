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
  end

  def delete
    id = params[:id]
    variable_to_delete = Variable.delete_all(:id=>id)
    respond_ok
  end
end
