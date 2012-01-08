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
//     [edit button][delete button]
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
// That object's format is as follows:
// <div class="ajaxcrud_editor" id="ajaxcrud_plural_model_name_editor">
//  [auto-generated body of labels and inputs]
//  <button id="save_model_name_button">Save</button>
//  <button id="cancel_model_name_button">Cancel</button>
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
function AjaxCrud(ui_selector, model_name, plural_model_name, controller_prefix) {
  this.ui_selector = ui_selector;
  this.model_name = model_name;
  this.plural_model_name = plural_model_name;
  this.controller_prefix = controller_prefix;
  // mappings from fields to entries in the CRUDable object.
  // format: [{display name, field name, type="text"|"checkbox"}]
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

  // Parses a CRUDable object into an HTML representation.
  this.row_html_content = function(crud_object) {
    var result = "";
    result += "<li class='row' id='"+this.model_name+"_"+crud_object["id"]+"'>";
    $.each(this.field_input_mappings, function (index, field_input_mapping) {
	result += "<div class='field field_" + field_input_mapping["field_name"] +
	  "'>" + crud_object[field_input_mapping["field_name"]] + "</div>";
      });
    result += "</li>"
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
      result += self.row_html_content(crud_object);
    });
    result += "</ul>";
    result += "<div class='controls'>";
    result += "<button id='add_" + this.model_name + "_button'>";
    result += "Add " + this.model_name + "</button>";
    result += "</div></div>";
    return result;
  }
  // TODO(mtomczak): get from server rule, rule to parse retrieved data into rows.
}