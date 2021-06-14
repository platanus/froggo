class RemoveUserIdFromPreferences < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :preferences, :user_id }
  end
end
