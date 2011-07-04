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
        @roles << role.model
      end
    end
  end
end
