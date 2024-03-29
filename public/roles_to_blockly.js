/**
 * Converts role database entries to Blockly blocks.
 * @author Mark T. Tomczak (iam@fixermark.com)
 */

if (!Blockly.Language) Blockly.Language = {};

/* To avoid namespace collisions, sub-category for us */
Blockly.Belphanior={};

/* Role name to hue converter, to create consistent colors for
 * roles. This simply sums the character codes in the role names and
 * converts the resulting sum into a 0-360 "hue" value.
 */
Blockly.Belphanior.nameToHue = function(name) {
  accum = 0;
  for(var i = 0; i < name.length; i++) {
    accum += name.charCodeAt(i);
  }
  return accum % 360;
}

/* Converts a role JSON to blocks in Blockly */
  Blockly.Belphanior.rolesToBlocks = function(rolesJson) {
    $.each(rolesJson, function (idx, roleJson) {
	var role = new Role(roleJson.model, roleJson.url);
	var category = "+ " + role.name();
	var roleUid = role.url;
	var roleHue = Blockly.Belphanior.nameToHue(roleUid);

	$.each(role.role.commands, function(cmdIdx, command) {
	var newBlock = {
	  category: category,
	  init: function () {
	    this.setColour(roleHue);
	    this.appendTitle(command["name"]);
	    if ('return' in command) {
	      this.setOutput(true, String);
	    } else {
	      this.setPreviousStatement(true);
	      this.setNextStatement(true);
	    }
	    var thisBlock = this;
	    var argDescriptions = "";
	    $.each(command['arguments'], function(argIdx, argument) {
		var argName = argument['name'];
		// Shorten for args that are essentially direct objects.
		if (command['arguments'].length == 1) {
		  argName = "";
		}

		thisBlock.appendInput(argName,
				      Blockly.INPUT_VALUE,
				      "INPUT" + argIdx,
				      null);
		argDescriptions += argument['name']
		  + ": " + argument["description"] + "\n";
	      });

	    this.setTooltip(function () {
		return command['description'] + "\n\n" + argDescriptions;
	      });
	  }
	};
	Blockly.Language["belphanior_" + roleUid + "|" + command["name"]] = newBlock;
	  });
      });
  };

// TODO(mtomczak): Block names will need to be computed from command identifiers, but they should be able to use all of the symbols that are valid for both role URLs and names.