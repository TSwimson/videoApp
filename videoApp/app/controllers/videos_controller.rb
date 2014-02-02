class VideosController < ApplicationController

  def index
    @videos = Video.all
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      @video.create_url
      if signed_in?
        current_user.videos << @video
      else
        @video.session_id = SecureRandom.urlsafe_base64(15)
        @video.delete_key = SecureRandom.urlsafe_base64(30)
        session[:owned_videos] ||= []
        session[:owned_videos] << @video.session_id
      end
      @video.save
      redirect_to videos_path, notice: "The video #{@video.name} has been uploaded."
    else
      render "new"
    end
  end

  def show
    @video = Video.find(params[:id])
  end

  def delete_page
    @video = Video.find(params[:id])
    if params[:delete_key] && params[:delete_key] == @video.delete_key
      render 'delete_page'
    else
      redirect_to "/"
    end

  end

  def destroy
    @video = Video.find(params[:id])
    debug_printer
    puts "params[:delete_key]: #{params}"
    if ((@video.user_id && owner?(@video.user_id)) || (params[:delete_key] && @video.delete_key && @video.delete_key == params[:delete_key]))
      @video.destroy
      redirect_to videos_path, notice:  "The video #{@video.name} has been deleted."
    else
      redirect_to videos_path, notes: "You are not authorized to delete this video"
    end

  end

  private

  def video_params
    params.require(:video).permit(:name, :attachment)
  end
end
