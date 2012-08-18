class AddBlocklyScripts < ActiveRecord::Migration
  class Script < ActiveRecord::Base
  end

  def up
    # format. Valid values are 'ruby' and 'blockly'
    add_column :scripts, :format, :string
    Script.reset_column_information
    Script.all.each do |script|
      script.update_attributes!(:format => "ruby")
    end
  end

  def down
    remove_column :scripts, :format
  end
end
