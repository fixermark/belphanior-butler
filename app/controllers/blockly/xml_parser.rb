# Converts Blockly XML into a tree of blockly code objects ready for evaluation.
require 'xmlsimple'
require 'blockly/code/boolean'
require 'blockly/code/count_with'
require 'blockly/code/clamp'
require 'blockly/code/get_variable'
require 'blockly/code/if'
require 'blockly/code/index_of'
require 'blockly/code/loop_break'
require 'blockly/code/op'
require 'blockly/code/not'
require 'blockly/code/number'
require 'blockly/code/plus_equals'
require 'blockly/code/set_variable'
require 'blockly/code/string'
require 'blockly/code/sequence'
require 'blockly/code/while'
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
        when 'text_join'
          result_block = parse_text_join block
        when 'text_append'
          result_block = parse_text_append block
        when 'text_length'
          result_block = parse_text_length block
        when 'text_isEmpty'
          result_block = parse_text_isEmpty block
        when 'text_endString'
          result_block = parse_text_endString block
        when 'text_indexOf'
          result_block = parse_text_indexOf block
        when 'text_charAt'
          result_block = parse_text_charAt block
        when 'text_changeCase'
          result_block = parse_text_changeCase block
        when 'text_trim'
          result_block = parse_text_trim block
        when 'text_print'
          result_block = parse_statement_print block
        # TODO(mtomczak): Remove 'text_prompt" from library; it's not
        # FOR us.
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
        when 'controls_whileUntil'
          result_block = parse_while block
        when 'controls_for'
          result_block = parse_count_with block
        when 'controls_flow_statements'
          result_block = parse_loop_flow block
        when /^belphanior_/
          result_block = parse_belphanior block
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
      def parse_text_join(block)
        text_blocks = []
        block['value'].each do |value|
          text_blocks << parse_block(value['block'][0])
        end
        Blockly::Code::TextJoin.new(next_block_id, text_blocks)
      end
      def parse_text_append(block)
        Blockly::Code::TextAppend.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]))
      end
      def parse_text_length(block)
        Blockly::Code::UnaryOp.new(
          next_block_id,
          :TEXTLENGTH,
          parse_block(block['value'][0]['block'][0]))
      end
      def parse_text_isEmpty(block)
        Blockly::Code::UnaryOp.new(
          next_block_id,
          :TEXTISEMPTY,
          parse_block(block['value'][0]['block'][0]))
      end
      def parse_text_endString(block)
        Blockly::Code::EndString.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['value'][1]['block'][0]))
      end
      def parse_text_indexOf(block)
        Blockly::Code::IndexOf.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['value'][1]['block'][0]))
      end
      def parse_text_charAt(block)
        Blockly::Code::Op.new(
          next_block_id,
          :TEXTCHARAT,
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['value'][1]['block'][0]))
      end
      def parse_text_changeCase(block)
        Blockly::Code::UnaryOp.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]))
      end
      def parse_text_trim(block)
        Blockly::Code::UnaryOp.new(
          next_block_id,
          "TRIMSPACES" + block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]))
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
      def parse_while(block)
        Blockly::Code::While.new(
          next_block_id,
          block['title'][0]['content'],
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['statement'][0]['block'][0]))
      end
      def parse_count_with(block)
        Blockly::Code::CountWith.new(
          next_block_id,
          block['variable'][0]['data'],
          parse_block(block['value'][0]['block'][0]),
          parse_block(block['value'][1]['block'][0]),
          parse_block(block['statement'][0]['block'][0]))
      end
      def parse_loop_flow(block)
          Blockly::Code::LoopBreak.new(
          next_block_id,
          block['title'][0]['content'])
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
      def parse_belphanior(block)
        args = []
        if block.has_key? 'value'
          block['value'].each do |value|
            args << parse_block(value['block'][0])
          end
        end
        role_uri, command_name = block['type'][11, block['type'].length].split("|")
        Blockly::Code::Belphanior.new(
          next_block_id,
          role_uri,
          command_name,
          args)
      end
    end
  end
end
