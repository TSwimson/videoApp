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
      @video.save
      redirect_to videos_path, notice: "The video #{@video.name} has been uploaded."
    else
      render "new"
    end
  end
 def show
  @video = Video.find(params[:id])
  binding.pry
 end
  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    redirect_to videos_path, notice:  "The video #{@video.name} has been deleted."
  end
 
private

  def video_params
    params.require(:video).permit(:name, :attachment)
  end
end
