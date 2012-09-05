# += for text

require 'blockly/code/root'
module Blockly
  module Code
    class TextAppend < Root
      def initialize(block_id, variable_name, append_value)
        super(block_id)
        @name = variable_name
        @value = append_value
      end
      def evaluate(context)
        current_value = context.get_local_variable_value(@name)
        context.set_local_variable_value(
          @name, current_value.to_s + @value.evaluate(context).to_s)
      end
    end
  end
end
