class CreateComment < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :text
      t.string :author
      t.integer :likes
      t.integer :dislikes
      t.float :rating
      t.integer :post_id
      t.timestamps
    end
  end
end
