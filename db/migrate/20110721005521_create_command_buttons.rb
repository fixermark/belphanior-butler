class CreateCommandButtons < ActiveRecord::Migration
  def self.up
    create_table :command_buttons do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :command_buttons
  end
end
