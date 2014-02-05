class AddExtensionToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :extension, :string
  end
end
