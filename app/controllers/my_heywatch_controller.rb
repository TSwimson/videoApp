class MyHeywatchController < ApplicationController
skip_before_filter :verify_authenticity_token
respond_to :json
  def upload_complete
     render json: {}
     encode params[:id], params['video_id']
  end

  def encode id, video_id
    hw = HeyWatch.new
    video = Video.find(id)
     hw.create :job, {
      :video_id =>  video_id, 
      format_id: "mp4_480p", 
      :output_url => "s3://#{ENV['AMAZON_ID']}:#{ENV['AMAZON_KEY']}@videosok/converted/#{video.attachment}", 
      ping_url: "http://web1.tunnlr.com:13011/hw/encoded/#{id}"
    }
  end

  def encode_complete
    video = Video.find(params[:id])
    video.url = "http://d1f5gutkqysysk.cloudfront.net/converted/#{video.attachment}"
    video.processed = "processed"
    video.save
    render json: {}
    #redirect user with gone
  end
end
