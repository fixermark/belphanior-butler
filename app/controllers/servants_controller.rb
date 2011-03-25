class ServantsController < ApplicationController
  def add_servant
    new_servant = Servant.new_from_json(request.raw_post)
    if not new_servant.save
      respond_app_error ("DuplicateRecord")
    else
      respond_ok
    end
  end

  def get_servants
    servants = Servant.find(:all)
    respond_with_json(servants)
  end

  def update_servant
  end

  def delete_servant
  end

end
