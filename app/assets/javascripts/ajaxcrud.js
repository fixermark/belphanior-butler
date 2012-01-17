// Copyright 2012 mark T. Tomczak
//
// Generalized handler for row-by-row CRUD-style information updating
// Handles creation, reading, updating, and deletion of a set of values by
// the use of a pre-specified template that maps inputs to field names.
//
// Requires: JQuery
//
// Layout of generated DOM object:
// <insertion point>
//  <div class="ajaxcrud" id="ajaxcrud_plural_model_name">
//   <div class='header'>
//     <div class='column field_field_name'>display_name</div>
//     . . .
//   </div>
//   <ul class="rows">
//    <li class="row" id="model_name_<id>">
//     <div class="field field_field_name">[data in field]</div>
//     <button id="button_edit_<model_name>_<id>">Edit</button>
//     <button id="button_delete_<model_name>_<id>">Delete</button>
//    </li>
//    . . .
//   </ul>
//   <div class="controls">
//    <button id="add_model_name_button">Add model_name</button>
//   </div>
//  </div>
// </insertion_point>
//
// Another DOM object is created to serve as the editor for creating or
// editing rows. It is spliced into the DOM at a sensible location
// (at the bottom for create, in the middle for edit).
// That object's format is as follows (where "identifier" is either
// <model_name> for add or <model_name>_<id> for edit):
// <div class="ajaxcrud_editor"
//  id="ajaxcrud_<identifier>_editor">
//  [auto-generated body of labels and inputs]
//  <button id="save_<identifier>_button">Save</button>
//  <button id="cancel_<identifier>_button">Cancel</button>
// </div>

// Ajax CRUD interaction handler.
//
// Args:
//  ui_selector: JQuery selector path to the DOM object at which
//   the model editor should be inserted.
//  model_name: Name of the model in Ruby.
//  plural_model_name: Pluralized name of the model in Ruby.
//  controller_prefix: the prefix for the path to the resources
//   that manipulate this object; the actual
//   URLS will be
//   controller_prefix/add_model_name,
//   controller_prefix/get_plural_model_name,
//   controller_prefix/update_model_name,
//   controller_prefix/delete_model_name
//  options: Dictionary of additional options:
//   get_message: Message to send to make an AJAX get request.
//   post_message: Message to send to make an AJAX post request.
function AjaxCrud(ui_selector, model_name, plural_model_name, controller_prefix, options) {
  this.ui_selector = ui_selector;
  this.model_name = model_name;
  this.plural_model_name = plural_model_name;
  this.controller_prefix = controller_prefix;
  this.get_message = options.get_message || "AJAX_GET";
  this.post_message = options.post_message || "AJAX_POST";

  // mappings from fields to entries in the CRUDable object.
  // format: [{display_name, field_name, type="text"|"checkbox"}]
  this.field_input_mappings = [];

  // add_* methods allow you to specify the input parameters that will
  // be expected from the JSON and how they map to the user interface.
  // This information will drive both the decoding and representation of
  // the model and the edit panel for the model.
  //
  // Usage example:
  //
  // AjaxCrud(<inputs>)
  //  .add_text_input("name", "name")
  //  .add_text_input("employee id", "emp_id")
  //  .add_checkbox_input("Likes pie", "pie");
  this.add_text_input = function(display_name, field_name) {
    this.field_input_mappings.push({
	"display_name" : display_name,
	"field_name" : field_name,
	"type" : "text"});
    return this;
  }
  this.add_checkbox_input = function(display_name, field_name) {
    this.field_input_mappings.push({
	"display_name" : display_name,
	"field_name" : field_name,
	"type" : "checkbox"});
    return this;
  }

  // Retrieves data from the server and displays it at the
  // node specified by ui_selector.
  this.read = function() {
    var self = this;
    Signal(this.get_message, {
	"fail_handler" : function(fail_data) {
	  throw "TODO(mtomczak): implement fail handler.";
	},
	"success_handler" : function(data) {
	  $(self.ui_selector).html(self.crud_html_content(data.data));
	  self.configure_buttons(data.data, self.model_name);
	}
      });
  }

  //////////
  // Internal methods
  //////////

  // Parses a CRUDable object into an HTML representation.
  //
  // Args:
  //   crud_object: CRUDable object.
  //   row_id: Unique identifier for the row.
  this.row_html_content = function(crud_object, row_id) {
    var result = "";
    result += "<li class='row' id='" + row_id + "'>";
    $.each(this.field_input_mappings, function (index, field_input_mapping) {
	result += "<div class='field field_" + field_input_mapping["field_name"] +
	  "'>" + crud_object[field_input_mapping["field_name"]] + "</div>";
      });
    result += "<div class='buttons' id='" + row_id + "_buttons'>";
    result += ("<button id='button_edit_" +
	       row_id + "'>Edit</button>");
    result += ("<button id='button_delete_" +
	       row_id + "'>Delete</button>");
    result += "</div>";
    result += "</li>";
    return result;
  }

  // Outputs the header for the data table.
  this.header_html_content = function() {
    var result = "<div class='header'>";
    $.each(this.field_input_mappings, function(index, field_input_mapping) {
	result += "<div class='column field_"
	  + field_input_mapping["field_name"]
	  + "'>" + field_input_mapping["display_name"]
	  + "</div>";
      });
    result += "</div>";

    return result;
  }

  // Converts data into an HTML representation.
  //
  // Args:
  //   data: Array of CRUD objects.
  //
  // Returns: The text HTML representation of the data.
  this.crud_html_content = function(data) {
    var self = this;
    var result = "<div class='ajaxcrud' id='ajaxcrud_"
      + this.plural_model_name + "'>";
    result += this.header_html_content();
    result += "<ul class='rows'>";
    $.each(data, function(index, crud_object) {
      var model_name_id = self.model_name + "_" + crud_object["id"];
      result += self.row_html_content(crud_object, model_name_id);
    });
    result += "</ul>";
    result += "<div class='controls'>";
    result += "<button id='button_add_" + this.model_name + "'>";
    result += "Add " + this.model_name + "</button>";
    result += "</div></div>";
    return result;
  }

  // Adds an editor at the specified location.
  //
  // Args:
  //   ui_selector: JQuery selector path to the add location. Editor will be
  //    appended under this location.
  //   editor_name: Name string used to generate unique IDs. Must be unique
  //    to this editor.
  //   edited_object: CRUD object to edit. Can be nil.
  //   save_callback: Method to run when "Save" is pressed.
  //    passed the JQuery representation of the edited object; if true is
  //    returned, editor is destroyed.
  //   cancel_callback: Method to run when "Cancel" is pressed. If callback is
  //   null or true is returned by callback, editor is
  //   destroyed.
  this.add_editor = function(ui_selector, editor_name, edited_object,
			     save_callback, cancel_callback) {
    var editor_id = 'ajaxcrud_' + editor_name + '_editor';
    var editor_node = $("<div class='ajaxcrud_editor' id='"
			+ editor_id + "'></div>");
    var editor_content = "";
    $.each(this.field_input_mappings, function(index, mapping) {
	editor_content += "<div class='input_label'>"
	  + mapping.display_name + "</div>";
	var input_id = "ajaxcrud_input_" + editor_name +
	  "_" + mapping.field_name + "'";
	var input_value = "";
	if (edited_object) {
	  if (mapping.type == "text") {
	    input_value = " value='" + edited_object[mapping.field_name] + "'";
	  } else { // Checkbox
	    if (edited_object[mapping.field_name]) {
	      input_value = " checked='checked'";
	    }
	  }
	}
	editor_content += "<input type='" + mapping.type +
	  "' id='" + input_id + input_value + "'/>";
      });
    var save_button_id = 'button_save_' + editor_name;
    var cancel_button_id = 'button_cancel_' + editor_name;
    editor_content += ("<button id='" + save_button_id +
		       "'>Save</button>");
    editor_content += ("<button id='" + cancel_button_id +
		       "'>Cancel</button>");
    editor_node.html(editor_content);
    $(ui_selector).append(editor_node);
    $("#" + save_button_id).button().click(function (evt) {
	// TODO(mtomczak): Bundle up data to save.
	if (save_callback({})) {
	  $("#" + editor_id).remove();
	}
      });
    $("#" + cancel_button_id).button().click(function (evt) {
	if (cancel_callback == null || cancel_callback()) {
	  $("#" + editor_id).remove();
	}
      });
  }

  // Configures the buttons in the user-interface (row edit / delete, new model)
  this.configure_buttons = function(crud_objects, model_name) {
    var self = this;
    $.each(crud_objects, function(index, crud_object) {
      var row_id = model_name + "_" + crud_object["id"];
      $("#button_edit_" + row_id).button().click(function(evt) {
	  $("#" + row_id + "_buttons").hide();
	  self.add_editor("#" + row_id,
			  row_id,
			  crud_object,
			  function () {
			    $("#" + row_id + "_buttons").show();
			    return true },
			  function () {
			    $("#" + row_id + "_buttons").show();
			    return true});

	});
      $("#button_delete_" + row_id).button();
    });
    $("#button_add_" + model_name).button();
  }

  // TODO(mtomczak): editor
}