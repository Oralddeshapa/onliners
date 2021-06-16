class UpdateCommentRating < ActiveRecord::Migration[6.1]
  def change
    change_table :comments do |t|
      t.change :rating, :string
    end
  end
end
