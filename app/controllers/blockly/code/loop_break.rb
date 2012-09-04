# Loop break statement (either continuation or full-break)

require 'blockly/code/root'

module Blockly
  module Code
    class LoopBreak < Root
      def initialize(block_id, break_type)
        super(block_id)
        @type = break_type.to_sym
      end
      def evaluate(context)
        raise LoopBreakException.new(@type)
      end
    end
  end
end
