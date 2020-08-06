class SlackCommandsService < PowerTypes::Service.new(:params)
  COMMAND_RESPONSES = {
    '/froggo' => :reply_hello,
    '/next_pr' => :reply_next_pr_recommendation,
    '/summary' => :reply_summary
  }

  def reply
    send(COMMAND_RESPONSES[command])
  end

  private

  def reply_hello
    I18n.t('messages.slack.hello')
  end

  def reply_next_pr_recommendation
    return I18n.t('messages.slack.next_pr_wrong_params') if wrong_params?
    return I18n.t('messages.slack.no_recommendations') if user_not_authorized?

    I18n.t('messages.slack.recommended_users', users: recommended_users.join(', '))
  end

  def reply_summary
    return I18n.t('messages.slack.summary_wrong_params') if wrong_params?
    return I18n.t('messages.slack.no_recommendations') if user_not_authorized?

    I18n.t('messages.slack.summary', obedient_count: statistics[:obedient],
                                     indifferent_count: statistics[:indifferent],
                                     rebel_count: statistics[:rebel])
  end

  def command
    @params['command']
  end

  def github_user_name
    @params['text'].split(' ').first
  end

  def organization_name
    @params['text'].split(' ').second
  end

  def github_user
    @github_user ||= GithubUser.find_by(login: github_user_name)
  end

  def organization
    @organization ||= Organization.find_by(login: organization_name)
  end

  def recommended_users
    recommendations = GetRecommendations.for(github_user: github_user,
                                             organization: organization)
    recommendations[:best].map { |user| user[:login] }
  end

  def statistics
    @statistics ||= ComputeUserStatistics.for(
      github_user_id: github_user.id,
      organization_id: organization.id
    )
  end

  def wrong_params?
    organization_name.nil? || organization.nil? || github_user.nil?
  end

  def user_not_authorized?
    membership = OrganizationMembership.find_by(github_user_id: github_user.id,
                                                organization_id: organization.id)
    !membership&.is_member_of_default_team
  end
end
