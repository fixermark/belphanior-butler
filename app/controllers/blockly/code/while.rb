# While block

require 'blockly/code/root'

module Blockly
  module Code
    class While < Root
      def initialize(block_id, repeat_mode, repeat_conditional, repeated_block)
        super(block_id)
        @mode = repeat_mode.to_sym
        @condition = repeat_conditional
        @block = repeated_block
      end
      def evaluate(context)
        while true # Loop continuously; condition evaluation will return
          # us from loop
          condition_truth = @condition.evaluate(context)
          case @mode
          when :WHILE
            if not condition_truth
              return
            end
          else  # :UNTIL
            if condition_truth
              return
            end
          end
          @block.evaluate(context)
        end
      end
    end
  end
end
