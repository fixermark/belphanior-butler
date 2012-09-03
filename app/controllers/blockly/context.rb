# The context in which a blockly script is evaluated
module Blockly
  class Context
    attr_reader :stdout
    def initialize
      @stdout = ""
    end
    def print(value)
      @stdout << value + "\n"
    end
  end
end
