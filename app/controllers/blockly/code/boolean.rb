# Simple Boolean value
require 'blockly/code/root'

module Blockly
  module Code
    class Boolean < Root
      def initialize(block_id, truth_value)
        super(block_id)
        @bool_value = false
        if truth_value == 'TRUE'
          @bool_value = true
        end
      end
      def evaluate(context)
        @bool_value
      end
    end
  end
end
