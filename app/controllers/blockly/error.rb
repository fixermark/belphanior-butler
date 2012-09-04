module Blockly
  class Error < Exception
  end
  class LoopBreakException < Exception
    attr_reader :type
    def initialize(break_type)
      @type = break_type
    end
  end
end
