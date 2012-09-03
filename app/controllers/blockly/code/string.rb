# A text string literal.
require 'blockly/code/root'
require 'blockly/error'
module Blockly
  module Code
    class String < Root
      def initialize(block_id, value)
        super(block_id)
        @value = value
      end
      def evaluate(context)
        @value
      end
    end
  end
end
