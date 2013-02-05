class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :user_id
      t.integer :parent_id
      t.integer :order

      t.timestamps
    end
      add_index :tasks, [:user_id, :parent_id, :order]
  end
end
