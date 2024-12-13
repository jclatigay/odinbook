class CreateFollowRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :follow_requests do |t|
      t.references :follower, foreign_key: { to_table: :users }
      t.references :followed, foreign_key: { to_table: :users }
      t.integer :status, default: 0

      t.timestamps
    end

    # Add an index for unique follow requests
    add_index :follow_requests, [ :follower_id, :followed_id ], unique: true
  end
end
