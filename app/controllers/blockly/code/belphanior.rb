# Binding between Blockly and Belphaior role calling system.

require 'blockly/code/root'

module Blockly
  module Code
    class Belphanior < Root
      def initialize(block_id, role_uri, command_name, arg_list)
        super(block_id)
        @role = role_uri
        @command = command_name
        @args = arg_list
      end
      def evaluate(context)
        arg_values = []
        @args.each do |arg|
          arg_values << arg.evaluate(context).to_s
        end
        return context.call_role(
          @role,
          @command,
          arg_values)
      end
    end
  end
end
