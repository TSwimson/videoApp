class AddviewsandprocessedtoVideos < ActiveRecord::Migration
  def change
    add_column :videos, :processed, :boolean
    add_column :videos, :views, :integer
  end
end
