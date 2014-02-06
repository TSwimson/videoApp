class MyHeywatchController < ApplicationController

  def upload_complete
    debug_print
    puts "u"*70
    puts "upload_complete params below"
    puts params
    #binding.pry
     encode params[:id], params['params']['video_id']
  end

  def encode id, video_id
    hw = HeyWatch.new
     hw.create :job, {
      :video_id =>  video_id, 
      format_id: "mp4_480p", 
      :output_url => "s3://#{ENV['AMAZON_ID']}:#{ENV['AMAZON_KEY']}@videosok/converted/abcd.mp4", 
      ping_url: "http://easyvid.heroku.com/hw/encoded/#{id}"
    }
    #binding.pry
  end

  def encode_complete
    debug_print
    puts "e"*70
    puts "encode_complete params below"
    puts params
    #binding.pry
    video = Video.find(params[:id])
    video.url = params[:output_url]
    video.processed = "processed"
    video.save
    #redirect user with gone
  end
end
