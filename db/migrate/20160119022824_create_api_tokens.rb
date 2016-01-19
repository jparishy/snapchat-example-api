class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.integer :user_id
      t.string :value

      t.timestamps null: false
    end
  end
end
