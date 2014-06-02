class CreateCredentialsTable < ActiveRecord::Migration
  def up
    create_table :credentials do |t|
      t.string :user_id, null: false
      t.string :credentials, null: false
    end
  end

  def down
    drop_table :credentials
  end
end
