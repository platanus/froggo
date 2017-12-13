class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :hooks, :type, :repo_type
  end
end
