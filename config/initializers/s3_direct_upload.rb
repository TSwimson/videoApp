module S3DirectUpload
  module UploadHelper
    class S3Uploader
      def url
        "http#{@options[:ssl] ? 's' : ''}://#{@options[:bucket]}.#{@options[:region]}.amazonaws.com/"
      end
    end
  end
end

S3DirectUpload.config do |c|
  c.access_key_id = ENV['AMAZON_ID']       # your access key id
  c.secret_access_key = ENV['AMAZON_KEY']   # your secret access key
  c.bucket = "videosok"              # your bucket name
  #c.region = 'us-west-1'             # region prefix of your bucket url. This is _required_ for the non-default AWS region, eg. "s3-eu-west-1"
  #c.url = 'http://s3-us-west-1.amazonaws.com'                # S3 API endpoint (optional), eg. "https://#{c.bucket}.s3.amazonaws.com/" 
end