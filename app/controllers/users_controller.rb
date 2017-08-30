class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    before_action :require_admin, only:[:destroy]
    
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
            flash[:success] = "Welcome to the WSP App #{@user.username}"
            redirect_to users_path
        else
            render 'new'
        end
    end
    
    def edit
        
    end
    
    def update
        
        if @user.update(user_params)
            flash[:success] = "Your account was updated successfully"
            redirect_to users_path
        else
            render 'edit'
        end
    end
    
    def show
       
       @user_articles = @user.articles.order('created_at DESC').paginate(page: params[:page], per_page: 5)
       @articlesuserid = @user.articles.first
    end
    
    def destroy
       @user = User.find(params[:id])
       @user.destroy
       flash[:danger] = "User and all scores created by user have been deleted"
       redirect_to users_path
    end
    
    def index
        @users = User.paginate(page: params[:page], per_page: 10)
    end
    
    private
    def user_params
        params.require(:user).permit(:username, :email, :password, :linemanager)
    end
    
    def require_same_user
        if !logged_in? || current_user != @user && !current_user.admin?
            flash[:danger] = "You can only edit your own account"
            redirect_to root_path
        end
    end
    
    def set_user
        @user = User.find(params[:id])
    end
    
    def require_admin
        if logged_in? && !current_user.admin?
            flash[:danger] = "Only admin users can perform that action"
            redirect_to root_path
        end
        
    end
    
end