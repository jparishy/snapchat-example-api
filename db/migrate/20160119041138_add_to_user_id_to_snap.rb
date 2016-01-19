class AddToUserIdToSnap < ActiveRecord::Migration
  def change
    add_column :snaps, :to_user_id, :integer
  end
end
