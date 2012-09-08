# Retrieve a global variable (i.e. Belphanior variable)

require 'blockly/code/root'

module Blockly
  module Code
    class GetGlobal < Root
      def initialize(block_id, global_name)
        super(block_id)
        @name = global_name
      end
      def evaluate(context)
        context.get_global_variable_value @name
      end
    end
  end
end

