class ChangeProcessedToStringForVideos < ActiveRecord::Migration
  def change
      remove_column :videos, :processed
      add_column :videos, :processed, :string
  end
end
