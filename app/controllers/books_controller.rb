class BooksController < ApplicationController
before_action :set_book, only: [:show, :edit, :update, :destroy]
before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def create
    @book = Book.new(book_params)
    @books = Book.all
    @book.user_id = Current.user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully." 
      #登録完了後、bookdetailへ
    else
      @users = User.all
      @user = Current.user
      render :index, status: :unprocessable_entity
      #エラー後、books画面へ
    end
  end

  def index
    @books = Book.all
    @user = Current.user
    @book = Book.new
    @book_comment = BookComment.new #コメント

  end

  def show
    @book = Book.new #投稿フォーム
    @user = @book_detail.user #BOOKの投稿者の情報全部
    @book_comment = BookComment.new #コメント
  end

  def edit
    @user = @book.user
    end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully." 
      #登録完了後、bookdetailへ
    else
      render :edit, status: :unprocessable_entity
      #エラー後、登録画面へ
    end
  end

  def destroy
    if @book.destroy
      redirect_to books_path
    else
      @books = Book.all
      render :index, status: :unprocessable_entity #失敗したらindexの戻す。ために、@booksが必要
    end
  end


  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def book_set
    @book = Book.find(params[:id])
  end

  def ensure_correct_user
    unless @book.user == Current.user
      redirect_to books_path
    end
  end
end
