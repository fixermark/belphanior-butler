# The context in which a blockly script is evaluated
require 'blockly/error'

module Blockly
  class Context
    attr_reader :stdout
    def initialize
      @stdout = ""
      # top of the stack is last
      @local_variables = {}
    end

    def print(value)
      @stdout << value + "\n"
    end

    # Retrieves the value of a variable. If the variable does not
    # exist, raises a Blockly error.
    def get_local_variable_value(variable_name)
      if not @local_variables.has_key? variable_name
        raise Error.new("Unable to find variable '#{variable_name}' in local variables.")
      else
        @local_variables[variable_name]
      end
    end

    def set_local_variable_value(variable_name, variable_value)
      @local_variables[variable_name] = variable_value
    end
  end
end
