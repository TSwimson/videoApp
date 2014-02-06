class MyHeywatchController < ApplicationController
skip_before_filter :verify_authenticity_token
  def upload_complete
    puts "upload_complete params below"
    puts params
    binding.remote_pry

     puts "request body"
     
     puts request.body.read
     render json: {}
     #encode params[:id], params['video_id']
  end

  def encode id, video_id
    hw = HeyWatch.new
     hw.create :job, {
      :video_id =>  video_id, 
      format_id: "mp4_480p", 
      :output_url => "s3://#{ENV['AMAZON_ID']}:#{ENV['AMAZON_KEY']}@videosok/converted/abcd.mp4", 
      ping_url: "http://easyvid.heroku.com/hw/encoded/#{id}"
    }
    binding.remote_pry
  end

  def encode_complete
    puts "encode_complete params below"
    puts params
    puts "request body"
    puts request.body.read
    binding.remote_pry
    video = Video.find(params[:id])
    video.url = params[:output_url]
    video.processed = "processed"
    video.save
    #redirect user with gone
  end
end
