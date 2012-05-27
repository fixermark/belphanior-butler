class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      # Name of the script. Must be unique.
      # Invariant: name must conform to Belphanior command rule
      # [a-z][0-9][space]
      t.string :name, :uniqueness => true
      # Command executed when the button is pushed.
      t.text :command
      t.timestamps
    end
  end
end
