class CreateSnaps < ActiveRecord::Migration
  def change
    create_table :snaps do |t|
      t.string :image_url
      t.timestamps null: false
    end
  end
end
