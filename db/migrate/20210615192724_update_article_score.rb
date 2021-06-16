class UpdateArticleScore < ActiveRecord::Migration[6.1]
  def change
    change_table :articles do |t|
      t.change :score, :string
    end
  end
end
