// Generalized logging engine

function Logger() {}

Logger.show_log = function() {
  $("#log").show();
}

Logger.hide_log = function() {
  $("#log").hide();
}

Logger.log = function(data) {
  $("#log_content").html(
    $("#log_content").html() + "<li><pre>" + data + "</pre></li>");
}