class AddDeleteUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :delete_url, :string
  end
end
