class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @target = params[:target] #選択された探す対象
    @word = params[:word] #検索窓に入力された文字
    @search = params[:search] #選択された検索方法

    if @target == "User"
      @users = User.looks(@search, @word)
    else @target == "Book"
      @books = Book.looks(@search, @word)
    end
  end

  #privateは不要 DBにcreate,updateするわけではないから
end
