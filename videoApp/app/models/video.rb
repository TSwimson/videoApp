# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  url         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  attachment  :string(255)
#  extension   :string(255)
#  session_id  :string(255)
#  user_id     :integer
#  delete_key  :string(255)
#

class Video < ActiveRecord::Base
	belongs_to :user
	#mount_uploader :attachment, VideoUploader

	def create_url filepath
		self.url = "http://d1f5gutkqysysk.cloudfront.net#{filepath}"
		self.get_extension
	end

	def get_extension
		self.extension = self.url.split(".").last
	end
end
