class UsersController < ApplicationController
  before_action :confirm_logged_in, :except => [:login, :logout, :attempt_login]

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(params.require(:user).permit(:show_permission, :edit_permission, :delete_permission, :comment_permission))
      redirect_to users_path
    else
      render edit_user_path
    end
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params.require(:user).permit(:email, :password, :password_confirmation))

  	if @user.save
  		redirect_to login_users_path
  	else
  		render "new"
  	end
  end

  def login
  	#display the login form
    @user = User.new
  end

  def attempt_login
    
    if params[:user][:email].present? && params[:user][:password].present?

      found_user = User.find_by_email(params[:user][:email])
      if found_user
        authorized_user = found_user.authenticate(params[:user][:password])
      end
    else
      render login_users_path
    end
      
    if authorized_user

      session[:user_email] = authorized_user.email
      session[:edit_permission] = authorized_user.edit_permission
      session[:show_permission] = authorized_user.edit_permission
      session[:delete_permission] = authorized_user.edit_permission
      session[:comment_permission] = authorized_user.edit_permission

      if authorized_user.role == ""
        #redirect_to message that no role has been assigned by admin
      redirect_to login_users_path

      elsif authorized_user.role == "admin"
        #redirect_to admin user
        redirect_to users_path

      else
        #redirect_to index of articles!
        redirect_to articles_path

      end
    else
      render login_users_path
    end
  end

  def logout
    session[:user_email] = nil
    session[:edit_permission] = nil
    session[:show_permission] = nil
    session[:create_permission] = nil
    session[:delete_permission] = nil
    session[:comment_permission] = nil
    session[:index_permission] = nil
    redirect_to login_users_path
  end

  def delete
    @user = User.find(params[:id])
    @user.destroy
  end

  private

  def confirm_logged_in
    unless session[:user_email]
      #notice please log in
      redirect_to login_users_path
      return false
    else
      return true  
    end
  end

end
