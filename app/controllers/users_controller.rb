class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create] 

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user) 
      #登録完了後、ログイン状態にする
      redirect_to user_path(Current.user.id), notice: "Welcome! You have signed up successfully." 
      #登録完了後、マイページへ
    else
      render:new, status: :unprocessable_entity
      #エラー後、登録画面へ
    end
  end

  def show
    @user = User.find(params[:id]) #ユーザー情報
    @book = Book.new #新規投稿
    @books = @user.books #ユーザーの投稿一覧
  end

  def edit
    @user = User.find(params[:id]) #ユーザー情報
  end

  def update
    @user = User.find(params[:id]) #ユーザー情報
    if @user.update
      redirect_to user_path(Current.user.id), notice: "You have updated user successfully." 
      #登録完了後、マイページへ
    else
      render :edit, status: :unprocessable_entity
      #エラー後、登録画面へ
    end
  end

 private
 
  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end

end
