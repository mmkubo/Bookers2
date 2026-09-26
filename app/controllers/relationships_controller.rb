class RelationshipsController < ApplicationController
  def create #フォローする
    @user = User.find(params[:user_id])
    Current.user.follow(@user)
    redirect_back(fallback_location: users_path)
  end

  def destroy #フォロー外す
    @user = User.find(params[:user_id])
    Current.user.unfollow(@user)
    redirect_back(fallback_location: users_path)
  end
end
