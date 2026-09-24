class BookCommentsController < ApplicationController
  def create
    @book_detail = Book.find(params[:book_id])
    @book_comment = Current.user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book_detail.id
    if @book_comment.save
      redirect_back(fallback_location: books_path(@book_detail)) #直前に戻る、履歴がなければshowへ戻る（どの本のshowか）
    else
      @book = Book.new
      @user = @book_detail.user 
      render :'books/show', status: :unprocessable_entity
    end
  end

  def destroy
    book = Book.find(params[:book_id])
    comment = Current.user.book_comments.find_by(book_id: book.id)
    comment.destroy
    redirect_back(fallback_location: books_path(book)) #直前に戻る、履歴がなければshowへ戻る（どの本のshowか）
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
