class RenameColumn < ActiveRecord::Migration
  def up
    rename_column :tasks, :order, :sort_order
  end

  def down
  end
end
