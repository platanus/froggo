class PullRequestsController < ApplicationController
    before_action :load_organization_by_name

    def index
        @pull_requests = PullRequest.by_organizations(@organization.id).limit(10)
        #@repositories = Repository.limit(605)
    end

    def load_organization_by_name
        @organization = Organization.find_by(login: params[:organization_name])
    end

end