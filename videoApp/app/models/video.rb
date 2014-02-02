class Video < ActiveRecord::Base
	mount_uploader :attachment, VideoUploader

	def create_url
		self.url = "http://d1f5gutkqysysk.cloudfront.net/#{self.attachment.path}"
		self.get_extension
		self.save
	end

	def get_extension
		self.extension = self.url.split(".").last
	end
	# def to_jq_upload
 #    {
 #      "name" => read_attribute(:attachment),
 #      "size" => attachment.size,
 #      "url" => attachment.url,
 #      #"thumbnail_url" => attachment.thumb.url,
 #      "delete_url" => "todothis", #picture_path(:id => id),
 #      "delete_type" => "DELETE" 
 #    }
 #  end
end
