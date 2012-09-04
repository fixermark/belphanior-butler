# Clamps a value between low and high values

require 'blockly/code/root'

module Blockly
  module Code
    class Clamp < Root
      def initialize(block_id, constrained_exp, low_exp, high_exp)
        super(block_id)
        @value = constrained_exp
        @low = low_exp
        @high = high_exp
      end
      def evaluate(context)
        value = @value.evaluate(context)
        low = @low.evaluate(context)
        high = @high.evaluate(context)

        if value < low
          low
        elsif value > high
          high
        else
          value
        end
      end
    end
  end
end
