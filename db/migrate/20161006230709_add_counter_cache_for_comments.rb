class AddCounterCacheForComments < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :comments_count, :integer
  end
end
