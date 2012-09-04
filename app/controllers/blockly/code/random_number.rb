# A random number between [0,1)

require 'blockly/code/root'

module Blockly
  module Code
    class RandomNumber < Root
      def initialize(block_id)
        super(block_id)
      end
      def evaluate(context)
        rand
      end
    end
  end
end
