class AddAttachmentToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :attachment, :string
  end
end
