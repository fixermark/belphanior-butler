# Negation operator
require 'blockly/code/root'

module Blockly
  module Code
    class Not < Root
      def initialize(block_id, negated_block)
        super(block_id)
        @negated_block = negated_block
      end
      def evaluate(context)
        not (@negated_block.evaluate(context))
      end
    end
  end
end
