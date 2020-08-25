class FroggoTeamsController < ApplicationController
  def new
    @organization = Organization.find(params[:organization_id])
    @users = @organization.members
  end
end
