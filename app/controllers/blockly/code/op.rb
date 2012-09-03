# Math and boolean operators
require 'blockly/code/root'

module Blockly
  module Code
    class Op < Root
      def initialize(block_id, op, input_1, input_2)
        super(block_id)
        @op = op.to_sym
        @input1 = input_1
        @input2 = input_2
      end
      def evaluate(context)
        value1 = @input1.evaluate(context)
        value2 = @input2.evaluate(context)
        case @op
        when :ADD
          value1 + value2
        when :MINUS
          value1 - value2
        when :MULTIPLY
          value1 * value2
        when :DIVIDE
          value1 / value2
        when :POWER
          value1 ** value2
        end
      end
    end
  end
end
