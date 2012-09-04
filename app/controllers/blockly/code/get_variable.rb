# Retrieves a (local) variable from the context.

require 'blockly/code/root'

module Blockly
  module Code
    class GetVariable < Root
      def initialize(block_id, variable_name)
        super(block_id)
        @name = variable_name
      end
      def evaluate(context)
        context.get_local_variable_value @name
      end
    end
  end
end
