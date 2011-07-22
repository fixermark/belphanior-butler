class ServantsController < ApplicationController
  def add_servant
    new_servant = Servant.new_from_json(request.raw_post)
    if not new_servant.save
      respond_app_error("DuplicateRecord")
    else
      respond_with_json(new_servant)
    end
  end

  def get_servants
    servants = Servant.find(:all)
    respond_with_json(servants)
  end

  def update_servant
  end

  def delete_servant
    name = params[:name]
    servant_to_delete = Servant.delete_all(:name=>name)
    respond_ok
  end

  def clear_role_cache
    Role.destroy_all()
    respond_ok
  end
end
