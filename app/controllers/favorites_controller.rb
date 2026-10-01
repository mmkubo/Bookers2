class FavoritesController < ApplicationController
  before_action :set_book, only: [:create, :destroy]

  def create
    @favorite = Current.user.favorites.new(book_id: @book.id)
    @favorite.save
    respond_to do |format|
      format.turbo_stream
      format.html{redirect_back(fallback_location: books_path)}
  end

  def destroy
    @favorite = Current.user.favorites.find_by(book_id: @book.id)
    @favorite&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html{redirect_back(fallback_location: books_path)}
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end
end
