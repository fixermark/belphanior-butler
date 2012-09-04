# Unary operator (essentially, a builtin function).
require 'blockly/code/root'

module Blockly
  module Code
    class UnaryOp < Root
      def initialize(block_id, operator, argument)
        super(block_id)
        @operator = operator.to_sym
        @argument = argument
      end
      def evaluate(context)
        value = @argument.evaluate(context)
        case @operator
        when :ROOT
          Math.sqrt value
        when :ABS
          value.abs
        when :NEG
          -(value)
        when :LN
          Math.log(value)
        when :LOG10
          Math.log10(value)
        when :EXP
          Math.exp(value)
        when :POW10
          10 ** value
        # Rounding
        when :ROUND
          value.round
        when :ROUNDUP
          value.ceil
        when :ROUNDDOWN
          value.floor
        # Trigonometry
        when :SIN
          Math.sin value
        when :COS
          Math.cos value
        when :TAN
          Math.tan value
        when :ASIN
          Math.asin value
        when :ACOS
          Math.acos value
        when :ATAN
          Math.atan value
        end
      end
    end
  end
end
