require 'json'

class DocumentationController < ApplicationController
  def index
    # Retrieves the documentation for all of the known
    # Roles.
    # See the Belphanior documentation for more information
    # on the formatting for a Role description.
    roles_from_db = Role.find(:all, :order=>"name ASC")
    @roles = []
    roles_from_db.each do |role|
      if role.model?
        @roles << {
          "url" => role.url.to_s,
          "model" => role.model}
      end
    end
  end
  def get
    # Retrieves the roles as a list.
    roles_from_db = Role.find(:all, :order=>"name ASC")
    roles = []
    roles_from_db.each do |role|
      if role.model?
        roles << {
          "url" => role.url.to_s,
          "model" => role.model}
      end
    end
    respond_with_json(:data => roles)
  end

end
