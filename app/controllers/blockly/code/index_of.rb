# Returns the location of the first (or last) occurrence of text in a
# larger text, or 0 if the text does not exist in the larger
# text. Note that indices are 1-offset.

require 'blockly/code/root'

module Blockly
  module Code
    class IndexOf < Root
      def initialize(block_id, first_or_last, needle, haystack)
        super(block_id)
        @first_or_last = first_or_last.to_sym
        @needle = needle
        @haystack = haystack
      end
      def evaluate(context)
        needle = @needle.evaluate(context).to_s
        haystack = @haystack.evaluate(context).to_s
        index = nil
        case @first_or_last
        when :FIRST
          index = haystack.index(needle)
        when :LAST
          index = haystack.rindex(needle)
        end
        if index == nil
          return 0
        end
        return index + 1
      end
    end
  end
end
