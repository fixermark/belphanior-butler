# Converts Blockly XML into a tree of blockly code objects ready for evaluation.
require 'xmlsimple'
require 'blockly/code/boolean'
require 'blockly/code/clamp'
require 'blockly/code/get_variable'
require 'blockly/code/if'
require 'blockly/code/op'
require 'blockly/code/not'
require 'blockly/code/number'
require 'blockly/code/plus_equals'
require 'blockly/code/set_variable'
require 'blockly/code/string'
require 'blockly/code/sequence'
require 'blockly/code/print'

module Blockly
  module Xml
    class Parser
      def initialize
        @block_id = 0
      end
      def next_block_id
        @block_id += 1
      end
      # Converts Blockly xml into a Blockly::Code object.
      def parse(xml_text)
        xml = XmlSimple.xml_in(xml_text, { 'ForceContent' => true })
        parse_block(xml['block'][0])
      end
      def parse_block(block)
        result_block = nil
        case block['type']
        when 'math_arithmetic'
          result_block = parse_arithmetic_op block
        when 'math_number'
          result_block = parse_number block
        when 'text'
          result_block = parse_text block
        when 'text_print'
          result_block = parse_statement_print block
        when 'logic_boolean'
          result_block = parse_boolean block
        when 'logic_compare'
          result_block = parse_logic_op block
        when 'logic_operation'
          result_block = parse_logic_op block
        when 'logic_negate'
          result_block = parse_not block
        when 'math_change'
          result_block = parse_math_change block
        when 'math_single'
          result_block = parse_math_single block
        when 'math_round'
          result_block = parse_math_single block
        when 'math_trig'
          result_block = parse_math_single block
        when 'math_constrain'
          result_block = parse_math_constrain block
        when 'math_modulo'
          result_block = parse_math_modulo block
        when 'math_random_int'
          result_block = parse_random_int block
        when 'math_random_float'
          result_block = parse_random_float block
        when 'variables_set'
          result_block = parse_variables_set block
        when 'variables_get'
          result_block = parse_variables_get block
        when 'controls_if'
          result_block = parse_if block
        end
        if block.has_key? "next"
          output = Code::Sequence.new(next_block_id)
          output.add_block(result_block)
          output.add_block(parse_block(block["next"][0]["block"][0]))
          return output
        else
          return result_block
        end
      end

      # TODO(mtomczak): In all parser statements, will need to clean
      # up to catch syntax failures Blockly allows (such as incomplete
      # blocks)
      def parse_arithmetic_op(block)
        Blockly::Code::Op.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['value'][1]['block'][0]))
      end
      def parse_logic_op(block)
        Blockly::Code::Op.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['value'][1]['block'][0]))
      end
      def parse_number(block)
        # TODO(mtomczak): Catch float conversion failure.
        Blockly::Code::Number.new(next_block_id, block['title'][0]['content'].to_f)
      end
      def parse_text(block)
        Blockly::Code::String.new(next_block_id, block['title'][0]['content'])
      end
      def parse_statement_print(block)
        Blockly::Code::Print.new(next_block_id, parse_block(block['value'][0]['block'][0]))
      end
      def parse_boolean(block)
        Blockly::Code::Boolean.new(next_block_id, block['title'][0]['content'])
      end
      def parse_not(block)
        Blockly::Code::Not.new(next_block_id, parse_block(block['value'][0]['block'][0]))
      end
      def parse_math_change(block)
        Blockly::Code::PlusEquals.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]))
      end
      def parse_math_single(block)
        Blockly::Code::UnaryOp.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]))
      end
      def parse_math_constrain(block)
        value_map = {}
        block['value'].each do |val|
          value_map[val['name']] = val['block'][0]
        end
        Blockly::Code::Clamp.new(
          next_block_id,
          parse_block(value_map['VALUE']),
          parse_block(value_map['LOW']),
          parse_block(value_map['HIGH']))
      end
      def parse_math_modulo(block)
        Blockly::Code::Op.new(
          next_block_id,
          :MODULO,
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['value'][1]['block'][0]))
      end
      def parse_random_int(block)
        Blockly::Code::Op.new(
          next_block_id,
          :RANDINT,
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['value'][1]['block'][0]))
      end
      def parse_random_float(block)
        Blockly::Code::RandomNumber.new(next_block_id)
      end
      def parse_if(block)
        # NOTE: If is mutable-structure; can include else-if and else subblocks
        # <value name='IF0'>
        # <statement name='DO0'>
        # <value name='IF1'>  // else if
        # <statement name='DO1'> // For every IFN block, a DON block
        # <statement name='ELSE'> // ... sometimes, an ELSE block to cap it all.
        if_blocks = []
        do_blocks = []
        block['value'].each do |value|
          if_blocks << parse_block(value['block'][0])
        end
        block['statement'].each do |statement|
          do_blocks << parse_block(statement['block'][0])
        end
        Blockly::Code::If.new(next_block_id, if_blocks, do_blocks)
      end
      def parse_variables_set(block)
        Blockly::Code::SetVariable.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]))
      end
      def parse_variables_get(block)
        Blockly::Code::GetVariable.new(
          next_block_id,
          block['title'][0]['content'])
      end
    end
  end
end
