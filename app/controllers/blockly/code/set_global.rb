# Sets a global (i.e. Belphanior system) variable.

require 'blockly/code/root'
module Blockly
  module Code
    class SetGlobal < Root
      def initialize(block_id, variable_name, variable_value)
        super(block_id)
        @name = variable_name
        @value = variable_value
      end
      def evaluate(context)
        context.set_global_variable_value(
          @name,
          @value.evaluate(context))
      end
    end
  end
end
