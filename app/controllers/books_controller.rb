class BooksController < ApplicationController

  def create
    @book = Book.new(book_params)
    @books = Book.all
    @book.user_id = Current.user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully." 
      #登録完了後、bookdetailへ
    else
      render :index, status: :unprocessable_entity
      #エラー後、books画面へ
    end
  end

  def index
    @books = Book.all
    @user = Current.user
    @book = Book.new
  end

  def show
    @book_detail = Book.find(params[:id]) #BOOK情報
    @book = Book.new #投稿フォーム
    @user = @book_detail.user #BOOKの投稿者の情報全部
  end

  def edit
    @book = Book.find(params[:id]) #ユーザー情報
  end

  def update
    @book = Book.find(params[:id]) #BOOK情報
    if @book.update(book_params)
      redirect_to book_path(params[:id]), notice: "You have updated book successfully." 
      #登録完了後、bookdetailへ
    else
      render :edit, status: :unprocessable_entity
      #エラー後、登録画面へ
    end
  end

  def destroy
    book = Book.find(params[:id])
    @books = Book.all
    if book.destroy
      redirect_to books_path
    else
      render :index, status: :unprocessable_entity
    end
  end


  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
