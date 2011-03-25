// Library to simplify communication to and from server of JSON data.
// Handles AJAX queries, success and failure.

// TODO(mtomczak): this looks complete. Gin up some simple onload tests for it.

// Error wrapper for Ajax object
function AjaxError(error_class, short_description, long_description) {
  this.error_class = error_class;
  this.short_description = short_description;
  this.long_description = long_description;
}

// Sends a query to the server with JSON. On success, provided callback
// method is executed with the response JSON as an argument. If a non-200 
// status is given in the return, a failure handler is instead triggered
// (if provided).

function Ajax(default_success_callback, default_fail_callback) {
  this.default_success_callback = default_success_callback;
  this.default_fail_callback = default_fail_callback;
  this.communicate = function(
    method, uri, data, success_callback, fail_callback) {
    $.ajax({
      type: method,
      url: uri,
      dataType: "json",
      success: this.success_handler(
        success_callback,
        fail_callback),
      error: this.error_handler(fail_callback)
    });      
  }

  this.get = function (uri, success_callback, fail_callback) {
    this.communicate("GET", uri, null, success_callback, fail_callback);
  }

  this.post = function (uri, data, success_callback, fail_callback) {
    this.communicate("POST", uri, data, success_callback, fail_callback);
  }

  this.success_handler = function(success_callback, fail_callback) {
    var ajax_object = this;
    return function(data, textStatus, jqXHR) {
      if (jqXHR.status != 200) {
        ajax_object.invoke_fail_callback(
          fail_callback,
          new AjaxError(
            "StatusError",
            "Response code was " + jqXHR.status + " instead of 200.",
            "Response code was " + jqXHR.status + " instead of 200.<br>" +
               "Document body:<br>" +
               jqXHR.responseText));
      } else {
        ajax_object.invoke_success_callback(success_callback, data);
      }
    }  // end success handler
  }

  this.error_handler = function(fail_callback) {
    var ajax_object = this;
    return function (jqXHR, textStatus, errorThrown) {
      if (jqXHR.status != 200) {
        ajax_object.invoke_fail_callback(
          fail_callback,
          new AjaxError(
            "StatusError",
            "Response code was " + jqXHR.status + " instead of 200.",
            "Response code was " + jqXHR.status + " instead of 200.<br>" +
               "Document body:<br>" +
               jqXHR.responseText));
      } else {
        ajax_object.invoke_fail_callback(
          fail_callback,
          new AjaxError(textStatus, textStatus, textStatus));
      }
    }  // end error handler
  }

  this.invoke_success_callback = function(
    success_callback, deserialized_object) {
    if (success_callback) {
      success_callback(deserialized_object);
    } else {
      this.default_success_callback(deserialized_object);
    }
  }

  this.invoke_fail_callback = function(fail_callback, error_data) {
    if (fail_callback) {
      fail_callback(error_data);
    } else {
      this.default_fail_callback(error_data);
    }
  }
}