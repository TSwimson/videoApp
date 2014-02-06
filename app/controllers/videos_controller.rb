class VideosController < ApplicationController

  #list all videos title and page link
  def index
    @videos = current_user.videos if signed_in?
    @videos ||= []
    @video = Video.new
  end

  #create a video
  #use a session and a delete key to allow the user to edit the video if they are not signed in
  #attach the video to their user account if they are signed in
  def create 
    @video = Video.new()                                                                     #get the attachemnt and create a video object with it

    if @video.save                                                                                   #if it saves then get the urll
      @video.create_url  params[:filepath]                                           

      if signed_in?                                                                                    #if the user is signed in add the video to their account
        current_user.videos << @video 

      else                                                                                                   #if they arent't uses sessions and a delete key
        @video.session_id = SecureRandom.urlsafe_base64(15) 
        @video.delete_key = SecureRandom.urlsafe_base64(30) 
        session[:owned_videos] ||= []                                                    #if the current session doesn't have any owned_videos then create the array
        session[:owned_videos] << @video.session_id                      #add videos session id to array
      end

      @video.save 
      send_to_heywatch @video
      render json:  {url: "/videos/#{@video.id}"}
    else                                                                                     #error saving the video take them back to try again TODO show errors
      redirect_to "/"
      
    end
  end
  #display the video
  #set the owner_type to one of 3 options
  #owner             -  the user is signed in and owns the video
  #not signed in - the user is not signed in but owns the video through the session
  #not owner      - the user doesn't own the video
  def show
    @video = Video.find(params[:id])
    @video.views += 1

    @video.save
    if owner? @video.user_id                                                        #for logged in owners of the video
      @owner_type = "owner" 
    elsif not_signed_in_owner? @video                                        #for non logged in owners of the video
      @owner_type = "not signed in"
    else                                                                                         #normal view of the video
      @owner_type = "not owner"
    end

  end

  #the page a non logged in user can use to delete the video
  #will only show up with a valid delete key
  def delete_page

    @video = Video.find(params[:id])
    if params[:delete_key] && params[:delete_key] == @video.delete_key #only show the page if the key matches
      render 'delete_page' 
    else                                                                                                                    #redirect to home if invalid
      redirect_to "/"
                                                                                                                              #TODO not authorized error
    end

  end

  # update the video only if the current user owns it through their account or session
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
    #first check if the user is logged in and the owner otherwise see if the delete key is valid
    if ((@video.user_id && owner?(@video.user_id)) || (params[:delete_key] && @video.delete_key && @video.delete_key == params[:delete_key]))
      @video.destroy
      redirect_to videos_path, notice:  "The video #{@video.name} has been deleted."
    else
      redirect_to videos_path, notes: "You are not authorized to delete this video"
    end

  end

  private

  # def video_attachment
  #   params.permit(:filepath)
  # end
  def send_to_heywatch video
    hw = HeyWatch.new
    debug_print
    puts hw.create :download, {
      :url => video.url, title: ((video.name || "untitled") + video.id.to_s + SecureRandom.urlsafe_base64(3)),
      :ping_url => "easyvid.com/hw/uploaded/#{video.id}"
    }
    binding.pry
  end
  def video_title
    params.require(:video).permit(:name)
  end
end
