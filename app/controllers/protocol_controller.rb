class ProtocolController < ApplicationController
  def index
    respond_with_json ({
      "roles" => [{
        "role_url" => "/do",
        "handlers" => [{
          "name" => "do",
          "method" => "POST",
          "path" => "/do",
          "data" => "{\"script_name\" : \"$(command)\" }"
        }]
      }]
    })
  end
end
