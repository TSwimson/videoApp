class VideosController < ApplicationController

  #list all videos title and page link
  def index
    @videos = Video.all
  end
  #new video page
  def new
    @video = Video.new
  end
  #create a video
  def create
    @video = Video.new(video_params) #get the attachemnt and create a video object with it
    if @video.save #check to see if it saves
      @video.create_url #Get the url for the video
      if signed_in?
        current_user.videos << @video #if the user is signed in add the video to their account
      else #setup the video for non logged in editting
        @video.session_id = SecureRandom.urlsafe_base64(15) #the session key used to update the video
        @video.delete_key = SecureRandom.urlsafe_base64(30) #used to delete the video without an acount 
        session[:owned_videos] ||= [] #if the current session doesn't have any owned_videos then create the array
        session[:owned_videos] << @video.session_id #add videos session id to array
      end
      @video.save 
      redirect_to videos_path, notice: "The video #{@video.name} has been uploaded."
    else #somethin when wrong saving the video take them back to try again TODO add show errors
      render "new"
    end
  end
  #display the video with the items for each of 3 types of viewers
  def show
    @video = Video.find(params[:id])
    if owner? @video.user_id #for logged in owners of the video
      @owner_type = "owner" 
    elsif not_signed_in_owner? @video #for non logged in owners of the video
      @owner_type = "not signed in"
    else  #normal views of the video
      @owner_type = "not owner"
    end
  end
  #the pages a non logged in user can use to delete the video
  def delete_page
    @video = Video.find(params[:id])
    if params[:delete_key] && params[:delete_key] == @video.delete_key #only show the page if the key matches
      render 'delete_page' #show the delete button and text
    else  #redirect to home if invalid
      redirect_to "/"
    end

  end
  # update the video only if the current user owns it or the session_id is in the session and < 24 hours passed
  def update
    @video = Video.find(params[:id])
    if owner?(@video.user_id)|| not_signed_in_owner?(@video)
      @video.update(video_title)
      redirect_to video_path(@video.id)
    else
      #TODO not authorized error
      redirect_to "/"
    end
  end
  # destroy only if owner or delete key is valid
  def destroy
    @video = Video.find(params[:id])
    #big if to first check if the user is logged in and the owner otherwise see if the delete key is valid
    if ((@video.user_id && owner?(@video.user_id)) || (params[:delete_key] && @video.delete_key && @video.delete_key == params[:delete_key]))
      @video.destroy
      redirect_to videos_path, notice:  "The video #{@video.name} has been deleted."
    else
      redirect_to videos_path, notes: "You are not authorized to delete this video"
    end

  end

  private

  def video_params
    params.require(:video).permit(:attachment)
  end

  def video_title
    params.require(:video).permit(:name)
  end
end
