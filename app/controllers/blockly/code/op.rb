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
        #arithmetic
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
        when :MODULO
          value1 % value2
        # comparison
        when :EQ
          value1 == value2
        when :NEQ
          value1 != value2
        # TODO(mtomczak): Should do type error catching here... Ruby
        # has no definition for bool < bool
        when :LT
          value1 < value2
        when :LTE
          value1 <= value2
        when :GT
          value1 > value2
        when :GTE
          value1 >= value2
        # boolean logic
        when :AND
          value1 and value2
        when :OR
          value1 or value2
        # random numbers
        when :RANDINT
          rand(value2 - value1 + 1) + value1
        end
      end
    end
  end
end
