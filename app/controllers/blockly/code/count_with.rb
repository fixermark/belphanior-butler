# For x from low to high

require 'blockly/code/root'

module Blockly
  module Code
    class CountWith < Root
      def initialize(block_id, variable_name, low_bound_block, high_bound_block, statement_to_loop)
        super(block_id)
        @name = variable_name
        @low_bound = low_bound_block
        @high_bound = high_bound_block
        @statement = statement_to_loop
      end
      def evaluate(context)
        context.set_local_variable_value(@name, @low_bound.evaluate(context))
        while (context.get_local_variable_value(@name) <
            (@high_bound.evaluate(context)))
          @statement.evaluate(context)
          context.set_local_variable_value(@name,
            context.get_local_variable_value(@name) + 1)
        end
      end
    end
  end
end
