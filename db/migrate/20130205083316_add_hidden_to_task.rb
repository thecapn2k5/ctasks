class AddHiddenToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :hidden, :boolean, :default => false
  end
end
