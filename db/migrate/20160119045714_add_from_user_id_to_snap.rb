class AddFromUserIdToSnap < ActiveRecord::Migration
  def change
    add_column :snaps, :from_user_id, :integer
  end
end
