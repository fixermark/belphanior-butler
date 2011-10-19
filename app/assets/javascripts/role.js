// A Role object, allowing access to the documentation of the
// role.
//
// Requires: json2.js, jquery

function Role(role_json_text, role_url) {
  this.role = JSON.parse(role_json_text);
  this.url = role_url

  this.name = function () {
    return this.role["name"];
  };

  this.to_html = function() {
    var out = "";
    out += "<div class='role_name'>" + this.name() + "</div>";
    if (this.role["description"]) {
      out += "<div class='role_description'>" + this.role["description"] 
        + "</div>";
    }
    out += "<div class='role_header'>Commands</div>";
    if (this.role["commands"]) {
      $.each(this.role["commands"], function(i, command) {
          if (command["name"]) {
            out += "<div class='role_command'>";
            out += "<div class='role_command_name'>" + command["name"] + "</div>";
            if (command["description"]) {
              out += "<div class='role_command_description'>" 
                + command["description"] + "</div>";
            }
            if (command["arguments"]) {
              out += "<div class='role_subheader'>Arguments</div>";
              out += "<ol class='role_command_arguments'>"
                $.each(command["arguments"], function(i, argument) {
                    if (argument["name"]) {
                      out += "<li><div class='role_command_argument_name'>"
                        + argument["name"] + "</div>";
                      if (argument["description"]) {
                        out += "<div class='role_command_argument_description'>"
                          + argument["description"] + "</div>";
                      }
                      out += "</li>";
                    }
                  });
              out += "</ol>";
              if (command["return"]) {
                out += "<div class='role_subheader'>Returns</div>";
                out += "<div class='role_command_return'>" + command["return"]
                  + "</div>";
              }
            }
            out += "</div>";
          }
        });
    }
    return out;
  };
}