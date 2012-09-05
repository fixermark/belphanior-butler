# Concatenates blocks (converted to strings) into one string.

require 'blockly/code/root'

module Blockly
  module Code
    class TextJoin < Root
      def initialize(block_id, text_block_list)
        super(block_id)
        @text_block_list = text_block_list
      end
      def evaluate(context)
        result = ""
        @text_block_list.each do |block|
          result += block.evaluate(context).to_s
        end
        result
      end
    end
  end
end
