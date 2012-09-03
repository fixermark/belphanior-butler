# A root blockly code object. All other code objects are children of Root.
require 'blockly/error'

module Blockly
  module Code
    class Root
      attr_reader :block_id
      def initialize(block_id)
        @block_id = block_id
      end
      def evaluate(context)
        # Must be overridden by all child classes.
        # Evaluates the code element and returns a value in ruby.
        raise Error("Evaluate called on a Root object that did not override it.")
      end
    end
  end
end
