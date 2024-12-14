class FollowRequestsController < ApplicationController
  def create
    @follow_request = current_user.follow_requests_sent.build(follow_request_params)

    if @follow_request.save
      redirect_back(fallback_location: users_path, notice: "Follow request sent!")
    else
      redirect_back(fallback_location: users_path, alert: "Unable to follow user.")
    end
  end

  def update
    @follow_request = FollowRequest.find(params[:id])
    if @follow_request.update(follow_request_params)
      redirect_back(fallback_location: user_path(@follow_request.followed), notice: "Follow request #{params[:follow_request][:status]}")
    else
      redirect_back(fallback_location: user_path(@follow_request.followed), alert: "Unable to update follow request")
    end
  end

  def destroy
    @follow_request = current_user.follow_requests_sent.find(params[:id])
    @follow_request.destroy
    redirect_back(fallback_location: users_path, alert: "Unfollowed successfully.")
  end

  private

  def follow_request_params
    params.require(:follow_request).permit(:followed_id, :status)
  end
end
