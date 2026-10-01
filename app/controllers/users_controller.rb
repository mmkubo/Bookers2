class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create] 
  before_action :set_user, only: [:show, :edit, :update]  
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user 
      #登録完了後、ログイン状態にする
      redirect_to user_path(@user), notice: "Welcome! You have signed up successfully." 
      #登録完了後、マイページへ
    else
      render :new, status: :unprocessable_entity
      #エラー後、登録画面へ
    end
  end

  def show
    @book = Book.new 
    @books = @user.books
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully." 
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def following
    @users = @user.followings
  end

  def followers
    @users = @user.followers
  end

 private
 
  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :introduction, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end
  
  def ensure_correct_user
    unless @user.id == Current.user.id
      redirect_to user_path(Current.user.id)
    end
  end

end
