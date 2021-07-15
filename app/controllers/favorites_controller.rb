class FavoritesController < ApplicationController

  def create
    @posts = Post.find(params[:post_id])
    unless @posts.favorited_by?(current_user)
      favorite = current_user.favorites.new(post_id: @posts.id)
      favorite.save
    end
    redirect_to post_path(@posts)
  end

  def destroy
    @posts = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @posts.id)
    favorite.destroy
    redirect_to post_path(@posts)
  end
end
