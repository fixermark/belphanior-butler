# If conditional
#
# If conditionals are interesting in Blockly, because they are mutable
# constructs... One if can have multiple 'else if' child clauses and
# at most one 'else' child clause. It is possible for all of the if
# clauses to be false; in that case, if there is no else clause, no
# statements are evaluated.

require 'blockly/code/root'

module Blockly
  module Code
    class If < Root
      def initialize(block_id, if_conditional_block_list, do_statement_block_list)
        super(block_id)
        @if_block_list = if_conditional_block_list
        @do_block_list = do_statement_block_list
      end
      def evaluate(context)
        # Note: As it is impossible in Blockly's syntax to capture the
        # return value from an if statement, by convention the
        # evaluation returns nil.
        @if_block_list.each_with_index do | conditional, i |
          if (conditional.evaluate(context))
            @do_block_list[i].evaluate(context)
            return nil
          end
        end
        if @do_block_list.length > @if_block_list.length
          # We have an else block
          @do_block_list.last.evaluate(context)
        end
        return nil
      end
    end
  end
end
