class Api::V1::LikesController < Api::V1::BaseController
  def create
    like = Like.new(create_params)
    if like.save
      render json: like
    else
      render json: { errors: like.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy
  end

  private

  def pull_request
    @pull_request ||= PullRequest.find(params.require(:pull_request_id))
  end

  def create_params
    { github_user: github_user, likeable: pull_request }
  end
end
