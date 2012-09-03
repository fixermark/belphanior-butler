# A sequence of blocks.

require 'blockly/code/root'

module Blockly
  module Code
    class Sequence < Root
      def initialize(block_id)
        super(block_id)
        @blocks = []
      end
      def add_block(block_to_add)
        # TODO(mtomczak): there's an optimization to avoid blowing
        # stack on long sequences... If you add a sequence, you should
        # collapse it s members into this sequence instead of building
        # a sequence (sequence (sequence (...  pattern.
        @blocks << block_to_add
      end
      def evaluate(context)
        # evaluates all the blocks (side-effects may matter) and then
        # returns the value of the last block.
        value = nil
        @blocks.each do |block|
          value = block.evaluate(context)
        end
        value
      end
    end
  end
end
