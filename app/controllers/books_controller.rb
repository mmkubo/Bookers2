class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @books = Book.all.sort_by{|book| book.popularity_sort_key}.reverse
    @book = Book.new
  end

  def show
    @book_comment = BookComment.new
    @book.increment!(:view_count)
  end

  def create
    @book = Current.user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully." 
    else
      @books = Book.all
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully." 
      #登録完了後、bookdetailへ
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @book.destroy
      redirect_to books_path
    else
      @books = Book.all
      render :index, status: :unprocessable_entity 
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def ensure_correct_user
    unless @book.user == Current.user
      redirect_to books_path
    end
  end
end
