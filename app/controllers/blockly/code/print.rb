# A print statement. Side-effect: Prints the argument.
require 'blockly/code/root'

module Blockly
  module Code
    class Print < Root
      def initialize(block_id, argument)
        super(block_id)
        @argument = argument
      end
      def evaluate(context)
        context.print(@argument.evaluate(context).to_s)
      end
    end
  end
end
