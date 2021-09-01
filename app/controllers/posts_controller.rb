class PostsController < ApplicationController
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to posts_path
  end

  def index
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post   #------ブランドタグ一覧を表示する-------
    @posts = @posts.page(params[:page]).reverse_order
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to posts_path
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def ensure_user
    @post = current_user.post
    @post = @post.find_by(params[:id])
    redirect_to post_path unless @post
  end

  def post_params
    params.require(:post).permit(:title, :body, :genre, :size, post_images_images: [], tag_ids: [])
  end
end