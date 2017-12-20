class AddResourceToHooks < ActiveRecord::Migration[5.1]
  def change
    add_reference :hooks, :resource, polymorphic: true
  end
end
