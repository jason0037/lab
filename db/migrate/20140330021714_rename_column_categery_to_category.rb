class RenameColumnCategeryToCategory < ActiveRecord::Migration
  def change
    rename_column :lab_eval_projects, :categery_id, :category_id
  end

  def down
    rename_column :lab_eval_projects, :category_id, :categery_id
  end
end
