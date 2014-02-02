class ChangeDeleteUrlToDeleteKeyForVideos < ActiveRecord::Migration
  def change
  	change_table :videos do |t|
      t.rename :delete_url, :delete_key
  	end
  end
end
