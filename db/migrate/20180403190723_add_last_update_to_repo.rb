class AddLastUpdateToRepo < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :last_update, :datetime
  end
end
