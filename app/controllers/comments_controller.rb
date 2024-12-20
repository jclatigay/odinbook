class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back(fallback_location: root_path, notice: "Comment created successfully")
    else
      redirect_back(fallback_location: root_path, alert: @comment.errors.full_messages.join(", "))
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_back(fallback_location: root_path, notice: "Comment updated successfully")
    else
      redirect_back(fallback_location: root_path, alert: @comment.errors.full_messages.join(", "))
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if @comment.user == current_user && @comment.destroy
      redirect_back(fallback_location: root_path, notice: "Comment deleted successfully")
    else
      redirect_back(fallback_location: root_path, alert: "You are not authorized to delete this comment")
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
