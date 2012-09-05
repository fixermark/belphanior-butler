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
        # Text
        when :TEXTLENGTH
          value.to_s.length
        when :TEXTISEMPTY
          value.to_s.empty?
        # TODO(mtomczak): These should be locale-sensitive, but for
        # now, we support ASCII-only.
        when :UPPERCASE
          value.to_s.upcase
        when :LOWERCASE
          value.to_s.downcase
        when :TITLECASE
          # Note: Requires Ruby on Rails.
          value.to_s.titleize
        when :TRIMSPACESLEFT
          value.to_s.lstrip
        when :TRIMSPACESRIGHT
          value.to_s.rstrip
        when :TRIMSPACESBOTH
          value.to_s.strip
        end
      end
    end
  end
end
