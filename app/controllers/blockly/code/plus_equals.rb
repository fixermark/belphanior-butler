# math_change block is +=, essentially

require 'blockly/code/root'

module Blockly
  module Code
    class PlusEquals < Root
      def initialize(block_id, variable_name, add_value)
        super(block_id)
        @name = variable_name
        @delta = add_value
      end
      def evaluate(context)
        variable_value = context.get_local_variable_value(@name)
        context.set_local_variable_value(@name, variable_value + @delta.evaluate(context))
      end
    end
  end
end
