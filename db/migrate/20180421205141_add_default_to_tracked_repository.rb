class AddDefaultToTrackedRepository < ActiveRecord::Migration[5.1]
  def change
    change_column :repositories, :tracked, :boolean, default: false
  end
end
