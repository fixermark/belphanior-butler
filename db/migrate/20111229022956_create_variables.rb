class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      # variable name.
      t.string :name
      # Variable content.
      t.text :value
      t.timestamps
    end
    add_index :variables, :name, :unique => true
  end
end
