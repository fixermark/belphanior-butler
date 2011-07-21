class CreateCommandButtons < ActiveRecord::Migration
  def self.up
    create_table :command_buttons do |t|
      # Name of the button.
      t.string :name
      # Command executed when the button is pushed.
      t.text :command
      t.timestamps
    end
  end

  def self.down
    drop_table :command_buttons
  end
end
