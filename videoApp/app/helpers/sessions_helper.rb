module SessionsHelper
	# signs in supplied user, called from SessionController
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    # current_user is avilable in controllers and views!
    # This is an is an assignment, which we must define - see below
    # note that next line is a call to setter 'def current_user=(user)' below
    current_user = user
    add_session_owned_videos
  end
  #user has logged in then add the videos saved in the session to their account
  def add_session_owned_videos
    debug_print
    return unless session[:owned_videos] #stop if the are no videos
    session[:owned_videos].each do |session_id| #get each video session id
      if video = Video.find_by_session_id(session_id) #get the video
        current_user.videos << video if (video.created_at + 24.hours > DateTime.now) #add it if it was created in the last 24 hours
        video.delete_key = nil #disable non logged in access
        video.session_id = nil
        video.save
        current_user.save
      end
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def debug_print
    puts (("#"*40)+"\n")*5
  end

  def not_signed_in_owner? video
    return false unless session[:owned_videos] 
    return false unless session[:owned_videos].include?(video.session_id)
    return false unless video.created_at + 24.hours > DateTime.now
    return true
  end

  def owner? id
    return false unless signed_in?
    return false unless current_user.id == id
    return true

  end
  # Authorization: signed_in_user is called in a before_filter
  # callback in each controller, see books/ingredients/recipe controllers
  # Ensures access to create/edit functions on if signed in.
  def signed_in_user
    unless signed_in?
      # If not signed in, save current location in session object
      # to be able to redirect after successful sign in.
      session[:return_to] = request.url
      # prompt sign in page
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  # signs out user by deleting @current_user and session cookie
  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
  end

  # Getter and setter for @current_user
  def current_user=(user)
    @current_user = user
  end

  # if current_user doesn't exist, check session cookie for user session
  # If exists, get the user record that belongs to that session.
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
end
