# configuration for s3 direct upload
module S3DirectUpload
  module UploadHelper
    # configure url
    class S3Uploader
      def url
        "http#{@options[:ssl] ? 's' : ''}://#{@options[:bucket]}.#{@options[:region]}.amazonaws.com/"
      end
    end
  end
end

S3DirectUpload.config do |c|
  c.access_key_id = ENV['AMAZON_ID']        # your access key id
  c.secret_access_key = ENV['AMAZON_KEY']   # your secret access key
  c.bucket = 'videosok'                     # your bucket name
end
