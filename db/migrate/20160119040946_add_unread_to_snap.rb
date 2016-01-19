class AddUnreadToSnap < ActiveRecord::Migration
  def change
    add_column :snaps, :unread, :boolean
  end
end
