# Sleep statement.

require 'blockly/code/root'

module Blockly
  module Code
    class Sleep < Root
      def initialize(block_id, sleep_time)
        super(block_id)
        @time = sleep_time
      end
      def evaluate(context)
        sleep(@time.evaluate(context))
      end
    end
  end
end
