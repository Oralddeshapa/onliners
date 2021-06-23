class ChangeColumnNameComment < ActiveRecord::Migration[6.1]
  def change
    rename_column :comments, :post_id, :article_id
  end
end
