# Grabs the front or back end of a string

require 'blockly/code/root'

module Blockly
  module Code
    class EndString < Root
      def initialize(block_id, operation, count, string)
        super(block_id)
        @operation = operation.to_sym
        @count = count
        @string = string
      end
      def evaluate(context)
        count = @count.evaluate(context).to_i
        string = @string.evaluate(context)
        case @operation
        when :FIRST
          string[0, count]
        when :LAST
          string[-count, count]
        end
      end
    end
  end
end
