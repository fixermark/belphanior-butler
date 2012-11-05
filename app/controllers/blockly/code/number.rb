# A literal blockly number
require 'blockly/code/root'

module Blockly
  module Code
    class Number < Root
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
