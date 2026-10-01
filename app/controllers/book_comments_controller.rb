class BookCommentsController < ApplicationController
  before_action :set_book, only: [:create, :destroy]
  before_action :ensure_correct_user, only: [:destroy]

  def create
    @book_comment = Current.user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book.id
    @book_comment = BookComment.new if @book_comment.save
    respond_to do |format|
      format.turbo_stream
      format.html{redirect_back(fallback_location:book_path(@book))}
    end
  end

  def destroy
    @book_comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html{redirect_back(fallback_location:book_path(@book))}
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def ensure_correct_user
    @book_comment = BookComment.find(params[:id])
    unless @book_comment.user == Current.user
      redirect_to book_path(@book)
    end
  end

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
