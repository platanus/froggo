class CreateOrganization < PowerTypes::Command.new(:token, :github_organization)
  def perform
    return if organization_exists?

    create_organization
  end

  private

  def organization_exists?
    !Organization.find_by(gh_id: @github_organization[:id]).nil?
  end

  def create_organization
    ActiveRecord::Base.transaction do
      @organization = Organization.create!(
        gh_id: @github_organization[:id],
        login: @github_organization[:login]
      )
      @organization_sync = OrganizationSync.create!(organization: @organization)
    end

    trigger_sync_for @organization_sync
    set_webhook_to @organization
  end

  def trigger_sync_for(organization_sync)
    OrganizationSyncJob.perform_later(organization_sync, @token)
  end

  def set_webhook_to(organization)
    Github::OrganizationWebhookService.new(token: @token, organization: organization).set
  end
end
