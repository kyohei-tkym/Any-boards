class PostCommentsController < ApplicationController
  before_action :ensure_user, only: [:destroy]

  def create
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = post.id
    comment.save
    redirect_to post_path(post)
  end

  def destroy
    PostComment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def ensure_user
    post_comments = current_user.post_comments
    post_comments = post_comments.find_by(params[:id], post_id: params[:post_id])
    redirect_to posts_path unless post_comments
  end

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
