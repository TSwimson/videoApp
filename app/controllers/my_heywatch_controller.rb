class MyHeywatchController < ApplicationController
skip_before_filter :verify_authenticity_token
respond_to :json
  def upload_complete
    #params.require(:params).permit(:video_id)
    logger.debug "upload_complete params below"
    logger.debug JSON.parse(request.body)
    #puts params

     #puts "request body"
     
     #puts request.body.read
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
  end

  def encode_complete
    puts "encode_complete params below"
    puts params
    puts "request body"
    puts request.body.read
    video = Video.find(params[:id])
    video.url = params[:output_url]
    video.processed = "processed"
    video.save
    #redirect user with gone
  end
end
