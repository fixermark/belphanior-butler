// Custom Blockly blocks

// TODO(mtomczak)
Blockly.Language.controls_sleep = {
  category: Blockly.LANG_CATEGORY_CONTROLS,
  init: function () {
    this.setColour(120);
    this.appendTitle("Sleep");
    this.appendInput("",
		     Blockly.INPUT_VALUE, 'VALUE', Number);
    this.setNextStatement(true);
    this.setPreviousStatement(true);
    this.setTooltip("Sleep for the specified number of seconds.");
  }
};

Blockly.Language.variables_global_get = {
  category: "Globals",
  init: function () {
    this.setColour(331);
    this.appendTitle("Get global");
    this.appendTitle(new Blockly.FieldDropdown(
      function () {
	var variable_options = [];
	Signal("GET_VARIABLE_NAMES", function (names) {
	    $.each(names, function(idx, name) {
		variable_options.push([name, name]);
	      });
	  });
	return variable_options;
      }), 'VAR');
    this.setOutput(true, String);
    this.setTooltip("Retrieves the value of a global variable.");
  }
};
Blockly.Language.variables_global_set = {
  category: "Globals",
  init: function () {
    this.setColour(331);
    this.appendTitle("Set global");
    this.appendTitle(new Blockly.FieldDropdown(
      function () {
	var variable_options = [];
	Signal("GET_VARIABLE_NAMES", function (names) {
	    $.each(names, function(idx, name) {
		variable_options.push([name, name]);
	      });
	  });
	return variable_options;
      }), 'VAR');
    this.appendInput("to",
		     Blockly.INPUT_VALUE, 'VALUE', null);
    this.setNextStatement(true);
    this.setPreviousStatement(true);
    this.setTooltip("Sets the value of a global variable (currently, string format only)");
  }
};


// Global set, get
// Do block?
