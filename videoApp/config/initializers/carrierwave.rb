CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['AMAZON_ID'],                        # required
    :aws_secret_access_key  => ENV['AMAZON_KEY'],                        # required
    :region                 => 'us-west-1',                  # optional, defaults to 'us-east-1'
    #:host                   => 's3.example.com',             # optional, defaults to nil
    :endpoint               => 'http://s3-us-west-1.amazonaws.com' # optional, defaults to nil
  }
  config.fog_directory  = 'videosok'                     # required
  #config.fog_public     = false                                   # optional, defaults to true
  #onfig.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end